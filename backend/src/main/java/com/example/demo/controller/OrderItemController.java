package com.example.demo.controller;

import com.example.demo.category.CreateCategoryDto;
import com.example.demo.category.UpdateCategoryDto;
import com.example.demo.order.CreateOrderDto;
import com.example.demo.order.CreateOrderItemDto;
import com.example.demo.order.Order;
import com.example.demo.order.OrderItem;
import com.example.demo.order.OrderRepository;
import com.example.demo.order.OrderService;
import com.example.demo.order.UpdateOrderDto;
import com.example.demo.order.UpdateOrderItemDto;
import com.example.demo.order.OrderItemRepository;
import com.example.demo.order.OrderItemService;
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
@RequestMapping("/orderitem")
public class OrderItemController {

    @Autowired
    private OrderItemService orderItemService;
  
    @GetMapping
    public List<OrderItem> getAllOrderItem() {
        return orderItemService.getAllOrderItem();
    }
    @GetMapping("/{id}")
    public OrderItem getOrderItem(@PathVariable long id) {
        return orderItemService.getOrderItem(id);
    }
    @PostMapping
    public  OrderItem createOrderItem(@RequestBody CreateOrderItemDto dto) {
        return orderItemService.createOrderItem(dto);
    }
    @PutMapping("/{id}")
    public OrderItem updateOrderItem(@PathVariable long id, @RequestBody UpdateOrderItemDto dto) {
        return orderItemService.updateOrderItem(id, dto);
    }
    @DeleteMapping("/{id}")
    public void deleteOrderItem(@PathVariable long id) {
        orderItemService.deleteOrderItem(id);;
    }
}
