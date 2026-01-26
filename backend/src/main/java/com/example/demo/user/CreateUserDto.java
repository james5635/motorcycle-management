package com.example.demo.user;

import lombok.Builder;

@Builder
public record CreateUserDto(
        String username,
        String email,
        String password,
        String phoneNumber,
        String address,
        String role,
        String profileImageUrl) {
}
