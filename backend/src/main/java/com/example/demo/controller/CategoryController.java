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

import com.example.demo.product.Product;
import com.example.demo.product.ProductService;
import com.example.demo.user.CreateUserDto;
import com.example.demo.user.UpdateUserDto;
import com.example.demo.user.User;
import com.example.demo.category.*;

@RestController
@RequestMapping("/category")
public class CategoryController {
   private final CategoryService categoryService;

    public CategoryController(
            CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping
    public List<Category> getAllCategory() {
        return categoryService.getAllCategory();
    }
    @GetMapping("/{id}")
    public Category getCategory(@PathVariable long id) {
        return categoryService.getCategory(id);
    }
    @PostMapping
    public Category createCategory(@RequestBody CreateCategoryDto dto) {
        return categoryService.createCategory(dto);
    }
    @PutMapping("/{id}")
    public Category updateCategory(@PathVariable long id, @RequestBody UpdateCategoryDto dto) {
        return categoryService.updateCategory(id, dto);
    }
    @DeleteMapping("/{id}")
    public void deleteCategory(@PathVariable long id) {
        categoryService.deleteCategory(id);;
    }
}
