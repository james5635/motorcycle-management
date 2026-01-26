package com.example.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import com.example.demo.user.CreateUserDto;
import com.example.demo.user.User;
import com.example.demo.user.UserService;

@Component
public class DatabaseSeeder implements CommandLineRunner {

    private final UserService userService;

    public DatabaseSeeder(UserService userService) {
        this.userService = userService;
    }

    @Override
    public void run(String... args) {
        if (userService.count() == 0) {
            CreateUserDto u1 = CreateUserDto.builder().username("jame").email("jame@gamil.com")
                    .password("helloworld")
                    .phoneNumber("2213123").address("phnom penh").role("Customer")
                    .profileImageUrl("https://aaa.comss")
                    .build();
            CreateUserDto u2 = CreateUserDto.builder().username("jonh").email("jonh@gmail.com")
                    .password("helloworld")
                    .phoneNumber("2213123").address("phnom penh").role("Customer")
                    .profileImageUrl("https://aaa.comas")
                    .build();
            userService.createUser(u1);
            userService.createUser(u2);

        }
    }
}