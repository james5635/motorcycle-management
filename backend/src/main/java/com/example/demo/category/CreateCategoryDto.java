package com.example.demo.category;

import lombok.Builder;

@Builder
public record CreateCategoryDto(
    String name, String description, String imageUrl) {

}