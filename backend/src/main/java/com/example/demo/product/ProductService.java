package com.example.demo.product;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.category.CategoryRepository;
import com.example.demo.category.Category;

@Service
public class ProductService {

    @Autowired
    private ProductRepository productRepository;
    @Autowired
    private CategoryRepository categoryRepository;

    public long count() {
        return productRepository.count();
    }

    public List<Product> getAllProduct() {
        return (List<Product>) productRepository.findAll();

    }

    public Product getProduct(long id) {
        return productRepository.findById(id).get();
    }

    public Product createProduct(CreateProductDto dto, String filename) {
        Category c = categoryRepository.findById(dto.categoryId()).get();

        Product p = Product.builder()
                .category(c)
                .name(dto.name())
                .description(dto.description())
                .price(dto.price())
                .stockQuantity(dto.stockQuantity())
                .imageUrl(filename)
                .brand(dto.brand())
                .modelYear(dto.modelYear())
                .engineCc(dto.engineCc())
                .color(dto.color())
                .conditionStatus(dto.conditionStatus())
                .createdAt(dto.createdAt())
                .build();
        return productRepository.save(p);
    }

    public Product updateProduct(long id, UpdateProductDto dto) {
        Product p = productRepository.findById(id).get();

        if (dto.categoryId().isPresent()) {
            Category c = categoryRepository.findById(dto.categoryId().get()).get();
            p.setCategory(c);
        }

        if (dto.name().isPresent()) {
            p.setName(dto.name().get());
        }
        if (dto.description().isPresent()) {
            p.setDescription(dto.description().get());
        }
        if (dto.price().isPresent()) {
            p.setPrice(dto.price().get());
        }
        if (dto.stockQuantity().isPresent()) {
            p.setStockQuantity(dto.stockQuantity().get());
        }
        if (dto.imageUrl().isPresent()) {
            p.setImageUrl(dto.imageUrl().get());
        }
        if (dto.brand().isPresent()) {
            p.setBrand(dto.brand().get());
        }
        if (dto.modelYear().isPresent()) {
            p.setModelYear(dto.modelYear().get());
        }
        if (dto.engineCc().isPresent()) {
            p.setEngineCc(dto.engineCc().get());
        }
        if (dto.color().isPresent()) {
            p.setColor(dto.color().get());
        }
        if (dto.conditionStatus().isPresent()) {
            p.setConditionStatus(dto.conditionStatus().get());
        }
        if (dto.createdAt().isPresent()) {
            p.setCreatedAt(dto.createdAt().get());
        }

        return productRepository.save(p);
    }

    public void deleteProduct(long id) {
        productRepository.deleteById(id);
    }

}