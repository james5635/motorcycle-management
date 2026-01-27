package com.example.demo.user;

import java.util.Optional;

public record UpdateUserDto(
        Optional<String> username,
        Optional<String> email,
        Optional<String> password,
        Optional<String> phoneNumber,
        Optional<String> address,
        Optional<String> role,
        Optional<String> profileImageUrl) {

}
