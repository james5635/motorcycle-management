package com.example.demo.order; 
import java.math.BigDecimal;
import java.time.LocalDateTime;



import lombok.Builder;

@Builder
public record CreateOrderDto(
                long userId,
                LocalDateTime orderDate,
                BigDecimal totalAmount,
                String status,
                String shippingAddress,
                String paymentMethod) {
}
