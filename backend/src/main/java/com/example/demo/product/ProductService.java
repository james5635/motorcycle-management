package com.example.demo.product;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ProductService {

    @Autowired
    private ProductRepository productRepository;

    public long count() {
        return productRepository.count();
    }

    public void save(Product p) {

        productRepository.save(p);
    }

    public List<Product> getAll() {
        return (List<Product>) productRepository.findAll();
    }
}