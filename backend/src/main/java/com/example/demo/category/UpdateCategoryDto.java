package com.example.demo.category;

import java.util.Optional;

public record UpdateCategoryDto(

        Optional<String> name, Optional<String> description, Optional<String> imageUrl) {

}
