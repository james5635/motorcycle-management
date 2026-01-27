package com.example.demo.category;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class CategoryService {

    @Autowired
    private CategoryRepository categoryRepository;

    CategoryService(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    public List<Category> getAllCategory() {
        return (List<Category>) categoryRepository.findAll();

    }

    public Category getCategory(long id) {
        return categoryRepository.findById(id).get();
    }

    public Category createCategory( CreateCategoryDto dto) {
        Category c = Category.builder().name(dto.name()).description(dto.description()).imageUrl(dto.imageUrl())
                .build();
        return categoryRepository.save(c);
    }
    public Category updateCategory(long id, UpdateCategoryDto dto) {
        Category c = categoryRepository.findById(id).get();
        if(dto.name().isPresent()){
            c.setName(dto.name().get());
        }
        if(dto.description().isPresent()){
            c.setDescription(dto.description().get());
        }
        if(dto.imageUrl().isPresent()){
            c.setImageUrl(dto.imageUrl().get());
        }
        
        return categoryRepository.save(c);
    }
    public void deleteCategory(long id) {
        categoryRepository.deleteById(id);
    }

}
