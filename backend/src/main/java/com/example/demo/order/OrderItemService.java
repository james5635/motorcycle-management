package com.example.demo.order;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.category.CreateCategoryDto;
import com.example.demo.category.UpdateCategoryDto;
import com.example.demo.product.Product;
import com.example.demo.product.ProductRepository;
import com.example.demo.user.User;
import com.example.demo.user.UserRepository;

import jakarta.persistence.Column;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Service
public class OrderItemService {
    @Autowired
    private OrderItemRepository orderItemRepository;
    @Autowired
    private ProductRepository productRepository;
    @Autowired
    private OrderRepository orderRepository;

    public List<OrderItem> getAllOrderItem() {
        return (List<OrderItem>) orderItemRepository.findAll();

    }

    public OrderItem getOrderItem(long id) {
        return orderItemRepository.findById(id).get();
    }

    public OrderItem createOrderItem(CreateOrderItemDto dto) {
        Order order = orderRepository.findById(dto.orderId()).get();
        Product product = productRepository.findById(dto.productId()).get();

        OrderItem c = OrderItem.builder()
                .order(order)
                .product(product)
                .quantity(dto.quantity())
                .unitPrice(dto.unitPrice())
                .build();

        return orderItemRepository.save(c);
    }

    public OrderItem updateOrderItem(long id, UpdateOrderItemDto dto) {
        OrderItem oi = orderItemRepository.findById(id).get();
        if (dto.orderId().isPresent()) {
            Order order = orderRepository.findById(dto.orderId().get()).get();
            oi.setOrder(order);

        }
        if (dto.productId().isPresent()) {
            Product product = productRepository.findById(dto.productId().get()).get();
            oi.setProduct(product);

        }
        if (dto.quantity().isPresent()) {
            oi.setQuantity(dto.quantity().get());
        }
        if (dto.unitPrice().isPresent()) {
            oi.setUnitPrice(dto.unitPrice().get());
        }
        return orderItemRepository.save(oi);
    }

    public void deleteOrderItem(long id) {
        orderItemRepository.deleteById(id);
    }

}
