package com.example.demo.order;

import com.example.demo.user.*;

import lombok.Builder;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Optional;

@Builder
public record UpdateOrderDto(
        Optional<Long> userId,
        Optional<LocalDateTime> orderDate,
        Optional<BigDecimal> totalAmount,
        Optional<String> status,
        Optional<String> shippingAddress,
        Optional<String> paymentMethod) {
}
