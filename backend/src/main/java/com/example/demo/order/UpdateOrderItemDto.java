package com.example.demo.order;
import java.math.BigDecimal;

import java.util.Optional;

import lombok.Builder;

@Builder
public record UpdateOrderItemDto(
        Optional<Long> orderId,
        Optional<Long> productId,
        Optional<Integer> quantity,
        Optional<BigDecimal> unitPrice) {
}
