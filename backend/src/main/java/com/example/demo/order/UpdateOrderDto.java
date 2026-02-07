package com.example.demo.order;

import com.example.demo.user.*;

import lombok.Builder;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Builder
public record UpdateOrderDto(
        long userId,
        LocalDateTime orderDate,
        BigDecimal totalAmount,
        String status,
        String shippingAddress,
        String paymentMethod) {
}
