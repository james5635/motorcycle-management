package com.example.demo.product;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Optional;

import com.example.demo.category.Category;

public record UpdateProductDto(
        Optional<Long> categoryId,
        Optional<String> name,
        Optional<String> description,
        Optional<BigDecimal> price,
        Optional<Integer> stockQuantity,
        Optional<String> imageUrl,
        Optional<String> brand,
        Optional<Integer> modelYear,
        Optional<Integer> engineCc,
        Optional<String> color,
        Optional<String> conditionStatus,
        Optional<LocalDateTime> createdAt) {
}
