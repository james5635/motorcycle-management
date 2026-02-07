package com.example.demo.order;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.user.User;
import com.example.demo.user.UserRepository;

import jakarta.persistence.Column;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Service
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;
    @Autowired
    private UserRepository userRepository;



    public Order createOrder(CreateOrderDto dto) {
        User user =  userRepository.findById(dto.userId()).get();
        Order order = Order.builder()
        .user(user)
        .orderDate(dto.orderDate())
        .totalAmount(dto.totalAmount())
        .status(dto.status())
        .shippingAddress(dto.shippingAddress())
        .paymentMethod(dto.paymentMethod())
        .build();
        return orderRepository.save(order);
    }



    public List<Order> findByUser(Long userId) {
        User user = userRepository.findById(userId).get();

        return orderRepository.findByUser(user);

    }
    
}
