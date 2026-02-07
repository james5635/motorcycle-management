package com.example.demo.order;

import java.math.BigDecimal;

import com.example.demo.product.Product;

import lombok.Builder;

@Builder
public record CreateOrderItemDto(
        long orderId,
        long productId,
        Integer quantity,
        BigDecimal unitPrice) {
}
