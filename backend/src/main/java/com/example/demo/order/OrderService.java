package com.example.demo.order;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.user.User;
import com.example.demo.user.UserRepository;


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
    public void deleteOrder(long id) {
        orderRepository.deleteById(id);
    }
    public Order updateOrder(long id, UpdateOrderDto dto) {
        Order order = orderRepository.findById(id).get();
        if (dto.userId().isPresent()) {
            User user = userRepository.findById(dto.userId().get()).get();
            order.setUser(user);
        }
        if (dto.orderDate().isPresent()) {
            order.setOrderDate(dto.orderDate().get());
        }
        if (dto.totalAmount().isPresent()) {
            order.setTotalAmount(dto.totalAmount().get());
        }
        if (dto.status().isPresent()) {
            order.setStatus(dto.status().get());
        }
        if (dto.shippingAddress().isPresent()) {
            order.setShippingAddress(dto.shippingAddress().get());
        }
        if (dto.paymentMethod().isPresent()) {
            order.setPaymentMethod(dto.paymentMethod().get());
        }
        return orderRepository.save(order);
    }
    
}
