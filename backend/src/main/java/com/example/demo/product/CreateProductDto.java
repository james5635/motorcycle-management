package com.example.demo.product;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.example.demo.category.Category;

import lombok.Builder;

@Builder
public record CreateProductDto(
        long categoryId,
        String name,
        String description,
        BigDecimal price,
        Integer stockQuantity,
        String brand,
        Integer modelYear,
        Integer engineCc,
        String color,
        String conditionStatus,
        LocalDateTime createdAt) {
}
