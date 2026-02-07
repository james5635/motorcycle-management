package com.example.demo.controller;

import com.example.demo.order.Order;
import com.example.demo.order.OrderItem;
import com.example.demo.order.OrderRepository;
import com.example.demo.order.OrderItemRepository;
import com.example.demo.user.UserRepository;
import com.example.demo.product.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderItemRepository orderItemRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ProductRepository productRepository;

    @PostMapping("/create")
    public ResponseEntity<?> createOrder(@RequestBody Map<String, Object> orderRequest) {
        try {
            Long userId = Long.valueOf(orderRequest.get("userId").toString());
            String shippingAddress = (String) orderRequest.get("shippingAddress");
            String paymentMethod = (String) orderRequest.get("paymentMethod");
            List<Map<String, Object>> items = (List<Map<String, Object>>) orderRequest.get("items");

            Order order = new Order();
            order.setUser(userRepository.findById(userId).orElseThrow());
            order.setShippingAddress(shippingAddress);
            order.setPaymentMethod(paymentMethod);
            
            BigDecimal totalAmount = BigDecimal.ZERO;
            for (Map<String, Object> item : items) {
                BigDecimal price = new BigDecimal(item.get("price").toString());
                int quantity = Integer.parseInt(item.get("quantity").toString());
                totalAmount = totalAmount.add(price.multiply(BigDecimal.valueOf(quantity)));
            }
            order.setTotalAmount(totalAmount);
            
            Order savedOrder = orderRepository.save(order);

            for (Map<String, Object> item : items) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrder(savedOrder);
                orderItem.setProduct(productRepository.findById(Long.valueOf(item.get("productId").toString())).orElseThrow());
                orderItem.setQuantity(Integer.parseInt(item.get("quantity").toString()));
                orderItem.setUnitPrice(new BigDecimal(item.get("price").toString()));
                orderItemRepository.save(orderItem);
            }

            return ResponseEntity.ok(savedOrder);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error creating order: " + e.getMessage());
        }
    }

    @GetMapping("/user/{userId}")
    public List<Order> getUserOrders(@PathVariable Long userId) {
        return orderRepository.findByUser_UserIdOrderByOrderDateDesc(userId);
    }
}
