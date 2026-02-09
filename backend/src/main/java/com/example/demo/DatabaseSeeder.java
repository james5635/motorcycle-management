package com.example.demo;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.Random;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.io.Resource;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import com.example.demo.category.CategoryService;
import com.example.demo.category.CreateCategoryDto;
import com.example.demo.product.CreateProductDto;
import com.example.demo.product.ProductService;
import com.example.demo.user.CreateUserDto;
import com.example.demo.user.User;
import com.example.demo.user.UserService;

import tools.jackson.databind.JsonNode;
import tools.jackson.databind.ObjectMapper;

@Component
public class DatabaseSeeder implements CommandLineRunner {

        private final UserService userService;
        private final CategoryService categoryService;
        private final ProductService productService;

        @Value("classpath:productSeed.json")
        private Resource productResource;
        @Autowired
        private ObjectMapper objectMapper;

        public DatabaseSeeder(UserService userService, CategoryService categoryService, ProductService productService) {
                this.userService = userService;
                this.categoryService = categoryService;
                this.productService = productService;
        }

        File randomUserImage() throws IOException {
                String uploadDir = "uploads/";
                Files.createDirectories(Paths.get(uploadDir));

                File folder = new File("../asset/user");
                File[] listOfFiles = folder.listFiles();
                File selectedFile = listOfFiles[new Random().nextInt(listOfFiles.length)];

                String filename = UUID.randomUUID() + "_" + selectedFile.getName();
                Path filePath = Paths.get(uploadDir, filename);

                Files.copy(selectedFile.toPath(), filePath);

                return filePath.toFile();
        }

        @Override
        public void run(String... args) throws IOException {
                if (userService.count() == 0) {
                        CreateUserDto u1 = CreateUserDto.builder().username("jame").email("jame@gamil.com")
                                        .password("123456")
                                        .phoneNumber("02213123").address("phnom penh").role("customer")
                                        // .profileImageUrl("https://aaa.comss")
                                        .build();
                        CreateUserDto u2 = CreateUserDto.builder().username("jonh").email("jonh@gmail.com")
                                        .password("123456")
                                        .phoneNumber("02213123").address("phnom penh").role("customer")
                                        // .profileImageUrl("https://aaa.comas")
                                        .build();

                        userService.createUser(u1, randomUserImage().getName());
                        userService.createUser(u2, randomUserImage().getName());
                }

                if (categoryService.getAllCategory().size() == 0) {
                        // );

                        CreateCategoryDto c1 = CreateCategoryDto.builder().name("Sport").description("abc")
                                        .imageUrl("abc.com")
                                        .build();
                        CreateCategoryDto c2 = CreateCategoryDto.builder().name("Cruiser").description("abc")
                                        .imageUrl("abc.com")
                                        .build();
                        CreateCategoryDto c3 = CreateCategoryDto.builder().name("Off-Road").description("abc")
                                        .imageUrl("abc.com")
                                        .build();
                        CreateCategoryDto c4 = CreateCategoryDto.builder().name("Scooter").description("abc")
                                        .imageUrl("abc.com")
                                        .build();
                        CreateCategoryDto c5 = CreateCategoryDto.builder().name("Touring").description("abc")
                                        .imageUrl("abc.com")
                                        .build();

                        categoryService.createCategory(c1);
                        categoryService.createCategory(c2);
                        categoryService.createCategory(c3);
                        categoryService.createCategory(c4);
                        categoryService.createCategory(c5);

                        JsonNode productNode = objectMapper.readTree(productResource.getInputStream());
                        for (JsonNode product : productNode) {

                                int categoryId = product.get("categoryId").asInt();
                                String name = product.get("name").asString();
                                String description = product.get("description").asString();
                                BigDecimal price = product.get("price").asDecimal();
                                int stockQuantity = product.get("stockQuantity").asInt();
                                String imageUrl = product.get("imageUrl").asString();
                                String brand = product.get("brand").asString();
                                int modelYear = product.get("modelYear").asInt();
                                int engineCc = product.get("engineCc").asInt();
                                String color = product.get("color").asString();
                                String conditionStatus = product.get("conditionStatus").asString();
                                LocalDateTime createdAt = LocalDateTime.parse(product.get("createdAt").asString());

                                CreateProductDto p = CreateProductDto.builder()
                                                .categoryId(categoryId)
                                                .name(name)
                                                .description(description)
                                                .price(price)
                                                .stockQuantity(stockQuantity)
                                                .brand(brand)
                                                .modelYear(modelYear)
                                                .engineCc(engineCc)
                                                .color(color)
                                                .conditionStatus(conditionStatus)
                                                .createdAt(createdAt)
                                                .build();

                                String uploadDir = "uploads/";
                                Files.createDirectories(Paths.get(uploadDir));

                                File file = new File("../asset/images/" + imageUrl);

                                String filename = UUID.randomUUID() + "_" + file.getName();
                                Path filePath = Paths.get(uploadDir, filename);

                                Files.copy(file.toPath(), filePath);

                                productService.createProduct(p, filename);

                        }
                }
        }
}