package com.example.demo;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Random;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import com.example.demo.category.CategoryService;
import com.example.demo.category.CreateCategoryDto;
import com.example.demo.user.CreateUserDto;
import com.example.demo.user.User;
import com.example.demo.user.UserService;

@Component
public class DatabaseSeeder implements CommandLineRunner {

    private final UserService userService;
    private final CategoryService categoryService;

    public DatabaseSeeder(UserService userService, CategoryService categoryService) {
        this.userService = userService;
        this.categoryService = categoryService;
    }

    File randomUserImage() throws IOException{
        String uploadDir = "uploads/";
        Files.createDirectories(Paths.get(uploadDir));

        File folder = new File("../asset/user");
        File[] listOfFiles = folder.listFiles();
        File selectedFile = listOfFiles[new Random().nextInt(listOfFiles.length)];

        String filename = UUID.randomUUID() + "_" +  selectedFile.getName();
        Path filePath = Paths.get(uploadDir, filename);

        Files.copy(selectedFile.toPath(), filePath);

        return filePath.toFile();
    }

    @Override
    public void run(String... args) throws IOException{
        if (userService.count() == 0) {
            CreateUserDto u1 = CreateUserDto.builder().username("jame").email("jame@gamil.com")
                    .password("123456")
                    .phoneNumber("02213123").address("phnom penh").role("Customer")
                    // .profileImageUrl("https://aaa.comss")
                    .build();
            CreateUserDto u2 = CreateUserDto.builder().username("jonh").email("jonh@gmail.com")
                    .password("123456")
                    .phoneNumber("02213123").address("phnom penh").role("Customer")
                    // .profileImageUrl("https://aaa.comas")
                    .build();

            userService.createUser(u1, randomUserImage().getName());
            userService.createUser(u2, randomUserImage().getName());
        }

        if (categoryService.getAllCategory().size() == 0) {
            //);

            CreateCategoryDto c1 = CreateCategoryDto.builder().name("Sport").description("abc").imageUrl("abc.com")
                    .build();
            CreateCategoryDto c2 = CreateCategoryDto.builder().name("Cruiser").description("abc").imageUrl("abc.com")
                    .build();
            CreateCategoryDto c3 = CreateCategoryDto.builder().name("Off-Road").description("abc").imageUrl("abc.com")
                    .build();
            CreateCategoryDto c4 = CreateCategoryDto.builder().name("Scooter").description("abc").imageUrl("abc.com")
                    .build();
            CreateCategoryDto c5 = CreateCategoryDto.builder().name("Touring").description("abc").imageUrl("abc.com")
                    .build();

            categoryService.createCategory(c1);
            categoryService.createCategory(c2);
            categoryService.createCategory(c3);
            categoryService.createCategory(c4);
            categoryService.createCategory(c5);

        }
    }
}