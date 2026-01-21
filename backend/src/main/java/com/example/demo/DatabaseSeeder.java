package com.example.demo;

import java.time.LocalDateTime;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import jakarta.persistence.Column;

@Component
public class DatabaseSeeder implements CommandLineRunner {

    private final UserService userService;

    public DatabaseSeeder(UserService userService) {
        this.userService = userService;
    }

    @Override
    public void run(String... args) {
        if (userService.count() == 0) {
            User u1 = User.builder().fullName("jame").email("jame@gamil.com")
                    .passwordHash("$2y$10$Cs/4ZSR7KqS8ujmUNgZnQ.2sXNEAV0iHph64pkGyYy0YRSbkQ1tEa")
                    .phoneNumber("2213123").address("phnom penh").role("Customer")
                    .profileImageUrl("https://aaa.com")
                    .build();
            User u2 = User.builder().fullName("jonh").email("jonh@gmail.com")
                    .passwordHash("$2y$10$Cs/4ZSR7KqS8ujmUNgZnQ.2sXNEAV0iHph64pkGyYy0YRSbkQ1tEa")
                    .phoneNumber("2213123").address("phnom penh").role("Customer")
                    .profileImageUrl("https://aaa.com")
                    .build();
            userService.save(u1);
            userService.save(u2);

        }
    }
}