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
        public UpdateUserDto withProfileImageUrl(String newUrl) {
                return new UpdateUserDto(username, email, password, phoneNumber, address, role, Optional.of(newUrl));
        }

}
