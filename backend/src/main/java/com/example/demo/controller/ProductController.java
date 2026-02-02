package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
    @PostMapping
    public Product createProduct(@RequestBody CreateProductDto dto) {
        return productService.createProduct(dto);
    }
    @PutMapping("/{id}")
    public Product updateProduct(@PathVariable long id, @RequestBody UpdateProductDto dto) {
        return productService.updateProduct(id, dto);
    }
    @DeleteMapping("/{id}")
    public void deleteProduct(@PathVariable long id) {
        productService.deleteProduct(id);;
    }
}
