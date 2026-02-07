package com.example.demo.order;

import java.math.BigDecimal;

import com.example.demo.product.Product;

import lombok.Builder;

@Builder
public record CreateOrderItemdto(
        long orderId,
        Product product,
        Integer quantity,
        BigDecimal unitPrice) {
}
