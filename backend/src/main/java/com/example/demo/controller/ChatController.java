package com.example.demo.controller;

import java.util.Map;

import org.springframework.ai.chat.model.ChatModel;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/chat")
public class ChatController {

    private final ChatModel chatModel;

    public ChatController(ChatModel chatModel) {
        this.chatModel = chatModel;
    }

    @PostMapping
    public Map<String, String> generate(@RequestBody Map<String, String> request) {
        if (request.get("prompt") == null || request.get("prompt").isBlank()){
            return Map.of("error", "prompt is required");
        }
        return Map.of("generation", chatModel.call(request.get("prompt")));
    }
}
