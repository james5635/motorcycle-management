package com.example.demo.order;
import java.math.BigDecimal;

import com.example.demo.product.*;

import lombok.Builder;

@Builder
public record UpdateOrderItemdto(
        long orderId,
        Product product,
        Integer quantity,
        BigDecimal unitPrice) {
}
