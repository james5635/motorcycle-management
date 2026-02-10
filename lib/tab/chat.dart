import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import '../config.dart';

enum MessageReaction { none, like, dislike }

class ChatMessage {
  final String text;
  final bool isUser;
  MessageReaction reaction;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.reaction = MessageReaction.none,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isThinking = false;
  String _currentStreamingText = '';

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    SSEClient.unsubscribeFromSSE();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isThinking = true;
      _currentStreamingText = '';
      _textController.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    await _streamResponse(text);
  }

  Future<void> _streamResponse(String prompt) async {
    SSEClient.unsubscribeFromSSE();

    try {
      await SSEClient.subscribeToSSE(
        method: SSERequestType.POST,
        url: "${config['apiUrl']}/chat",
        header: {'Content-Type': 'application/json'},
        body: {'prompt': prompt},
      ).listen(
        (event) {
          if (!mounted) return;

          if (_isThinking) {
            setState(() {
              _isThinking = false;
            });
          }

          final data = event.data;
          if (data != null && data.isNotEmpty) {
            setState(() {
              final newData = data.substring(0, data.length - 1);
              _currentStreamingText += newData;
            });
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _scrollToBottom(),
            );
          }
        },
        onDone: () {
          if (mounted && _currentStreamingText.isNotEmpty) {
            setState(() {
              _messages.add(
                ChatMessage(text: _currentStreamingText, isUser: false),
              );
              _currentStreamingText = '';
            });
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() {
              _isThinking = false;
              _messages.add(
                ChatMessage(
                  text: 'Error: Failed to get response. Please try again.',
                  isUser: false,
                ),
              );
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isThinking = false;
          _messages.add(
            ChatMessage(
              text: 'Error: Failed to get response. Please try again.',
              isUser: false,
            ),
          );
        });
      }
    }
  }

  void _setReaction(int index, MessageReaction reaction) {
    setState(() {
      if (_messages[index].reaction == reaction) {
        _messages[index].reaction = MessageReaction.none;
      } else {
        _messages[index].reaction = reaction;
      }
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildAvatar(bool isUser) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isUser ? Colors.blue[100] : Colors.purple[100],
        shape: BoxShape.circle,
        border: Border.all(
          color: isUser ? Colors.blue : Colors.purple,
          width: 2,
        ),
      ),
      child: Icon(
        isUser ? Icons.person : Icons.smart_toy,
        color: isUser ? Colors.blue : Colors.purple,
        size: 20,
      ),
    );
  }

  Widget _buildReactions(int index) {
    final message = _messages[index];
    if (message.isUser) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(left: 44, top: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              Icons.thumb_up_outlined,
              size: 18,
              color: message.reaction == MessageReaction.like
                  ? Colors.green
                  : Colors.grey[600],
            ),
            onPressed: () => _setReaction(index, MessageReaction.like),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              Icons.thumb_down_outlined,
              size: 18,
              color: message.reaction == MessageReaction.dislike
                  ? Colors.red
                  : Colors.grey[600],
            ),
            onPressed: () => _setReaction(index, MessageReaction.dislike),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.copy_outlined, size: 18, color: Colors.grey[600]),
            onPressed: () => _copyToClipboard(message.text),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(ChatMessage message) {
    if (message.isUser) {
      return Text(
        message.text,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      );
    }
    // Render AI messages as markdown
    return GptMarkdown(
      message.text,
      style: const TextStyle(color: Colors.black87, fontSize: 15),
    );
  }

  Widget _buildMessage(ChatMessage message, int index) {
    return Column(
      crossAxisAlignment: message.isUser
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            mainAxisAlignment: message.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!message.isUser) ...[
                _buildAvatar(false),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: message.isUser
                        ? LinearGradient(
                            colors: [Colors.blue[400]!, Colors.blue[600]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: message.isUser ? null : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  child: _buildMessageContent(message),
                ),
              ),
              if (message.isUser) ...[
                const SizedBox(width: 8),
                _buildAvatar(true),
              ],
            ],
          ),
        ),
        _buildReactions(index),
      ],
    );
  }

  Widget _buildThinkingIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildAvatar(false),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.grey[600]!,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Thinking...',
                  style: TextStyle(color: Colors.grey[600], fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreamingMessage() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildAvatar(false),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              // Use GptMarkdown for streaming as well for consistency
              child: GptMarkdown(
                _currentStreamingText,
                style: const TextStyle(color: Colors.black87, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.smart_toy, color: Colors.purple[700]),
            const SizedBox(width: 8),
            Text(
              'AI Assistant',
              style: TextStyle(
                color: Colors.purple[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (_messages.isEmpty && !_isThinking)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 64,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Start a conversation',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8),
                itemCount:
                    _messages.length +
                    (_isThinking || _currentStreamingText.isNotEmpty ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _messages.length) {
                    return _buildMessage(_messages[index], index);
                  }
                  if (_isThinking) {
                    return _buildThinkingIndicator();
                  }
                  return _buildStreamingMessage();
                },
              ),
            ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[400]!, Colors.blue[600]!],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _isThinking || _currentStreamingText.isNotEmpty
                          ? null
                          : _sendMessage,
                      icon: const Icon(Icons.send),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
