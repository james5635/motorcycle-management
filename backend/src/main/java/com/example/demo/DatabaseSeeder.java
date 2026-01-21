package com.example.demo;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;


@Component
public class DatabaseSeeder implements CommandLineRunner {

    private final UserService userService;

    private final PasswordEncoder encoder;

    @Autowired
    public DatabaseSeeder(UserService userService, PasswordEncoder encoder) {
        this.userService = userService;
        this.encoder = encoder;
    }

    @Override
    public void run(String... args) {
        if (userService.count() == 0) {
            User u1 = User.builder().fullName("jame").email("jame@gamil.com")
                    .passwordHash(encoder.encode("hello"))
                    .phoneNumber("2213123").address("phnom penh").role("Customer")
                    .profileImageUrl("https://aaa.comss")
                    .build();
            User u2 = User.builder().fullName("jonh").email("jonh@gmail.com")
                    .passwordHash(encoder.encode("hello"))
                    .phoneNumber("2213123").address("phnom penh").role("Customer")
                    .profileImageUrl("https://aaa.comas")
                    .build();
            // userService.save(u1);
            // userService.save(u2);

        }
    }
}