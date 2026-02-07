package com.example.demo.controller;

import com.example.demo.category.CreateCategoryDto;
import com.example.demo.category.UpdateCategoryDto;
import com.example.demo.order.CreateOrderDto;
import com.example.demo.order.Order;
import com.example.demo.order.OrderItem;
import com.example.demo.order.OrderRepository;
import com.example.demo.order.OrderService;
import com.example.demo.order.UpdateOrderDto;
import com.example.demo.order.OrderItemRepository;
import com.example.demo.user.UserRepository;
import com.example.demo.product.CreateProductDto;
import com.example.demo.product.Product;
import com.example.demo.product.ProductRepository;
import com.example.demo.product.UpdateProductDto;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/order")
public class OrderController {

    @Autowired
    private OrderService orderService;
  
    @GetMapping("/user/{userId}")
    public List<Order> getOrdersByUser(@PathVariable Long userId) {
        return orderService.findByUser(userId);
    }
    @PostMapping
    public  Order createOrder(@RequestBody CreateOrderDto dto) {
        return orderService.createOrder(dto);
    }
    @PutMapping("/{id}")
    public Order updateOrder(@PathVariable long id, @RequestBody UpdateOrderDto dto) {
        return orderService.updateOrder(id, dto);
    }
    @DeleteMapping("/{id}")
    public void deleteOrder(@PathVariable long id) {
        orderService.deleteOrder(id);;
    }
}
