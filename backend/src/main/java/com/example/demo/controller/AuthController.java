package com.example.demo.controller;

import java.util.Map;

import org.apache.catalina.connector.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.user.UserService;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@RequestBody Map<String, String> l) {
        String username = l.get("username");
        String password = l.get("password");
        if (username == null || password == null) {
       ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(
                Map.of("error", "username or password cannot be null"));
        }
        return userService.loginUser(username, password);
    }

    
}
