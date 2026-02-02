package com.example.demo.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.product.CreateProductDto;
import com.example.demo.product.Product;
import com.example.demo.product.ProductService;
import com.example.demo.product.UpdateProductDto;

@RestController
@RequestMapping("/product")
public class ProductController {
    private final ProductService productService;

    public ProductController(
            ProductService productService) {
        this.productService = productService;
    }

    @GetMapping
    public List<Product> getAllProduct() {
        return productService.getAllProduct();
    }

    @GetMapping("/{id}")
    public Product getProduct(@PathVariable long id) {
        return productService.getProduct(id);
    }

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public Product createProduct(
            @RequestPart("product") CreateProductDto dto,
            @RequestPart(value = "productImage", required = false) MultipartFile file) throws IOException {
        String uploadDir = "uploads/";
        Files.createDirectories(Paths.get(uploadDir));

        String filename = UUID.randomUUID() + "_" + file.getOriginalFilename();
        Path filePath = Paths.get(uploadDir, filename);

        Files.copy(file.getInputStream(), filePath);

        return productService.createProduct(dto, filename);
    }

    @PutMapping(value = "/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public Product updateProduct(
            @PathVariable long id,
            @RequestPart("product") UpdateProductDto dto,
            @RequestPart(value = "productImage", required = false) MultipartFile file) throws IOException {

        if (file != null && !file.isEmpty()) {
            String uploadDir = "uploads/";
            Files.createDirectories(Paths.get(uploadDir));

            String filename = UUID.randomUUID() + "_" + file.getOriginalFilename();
            Path filePath = Paths.get(uploadDir, filename);

            Files.copy(file.getInputStream(), filePath);

            dto = dto.withProductImageUrl(filename);
        }
        return productService.updateProduct(id, dto);
    }

    @DeleteMapping("/{id}")
    public void deleteProduct(@PathVariable long id) {
        productService.deleteProduct(id);
        ;
    }
}
