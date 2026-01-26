package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.product.Product;
import com.example.demo.product.ProductService;
import com.example.demo.user.UserService;

@RestController
@RequestMapping("/product")
public class ProductController {
    private final ProductService productService;

    public ProductController(
            ProductService productService) {
        this.productService = productService;
    }
      @PostMapping("/product")
    public void saveProduct(@RequestBody Product p) {
        productService.save(p);
    }

    @GetMapping("/product")
    public List<Product> getAllProduct() {
        return productService.getAll();
    }
}
