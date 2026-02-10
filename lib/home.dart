import 'package:flutter/material.dart';
import 'package:motorcycle_management/tab/chat.dart';
import 'package:motorcycle_management/tab/motorcycle.dart';
import 'package:motorcycle_management/tab/setting.dart';
import 'package:motorcycle_management/tab/home.dart';
import 'package:motorcycle_management/tab/upload.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Widget>? _pages;
  Map<String, dynamic>? _userData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_pages == null) {
      _userData =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      _pages = [
        HomeTab(),
        ProductGridScreen(),
        UploadScreen(),
        ChatScreen(userData: _userData),
        ProfileSettingScreen(userId: _userData?["userId"] ?? 0),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages!),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.motorcycle),
            label: "Motorcycles",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: "Upload"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
