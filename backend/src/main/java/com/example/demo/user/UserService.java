package com.example.demo.user;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private PasswordEncoder encoder;

   

    public User createUser(CreateUserDto dto) {
        User user = User.builder().fullName(dto.username()).email(dto.email())
                .passwordHash(encoder.encode(dto.password())).phoneNumber(dto.phoneNumber()).address(dto.address())
                .role(dto.role()).profileImageUrl(dto.profileImageUrl()).build();
        return userRepository.save(user);

    }

    public List<User> getAllUser() {
        return (List<User>) userRepository.findAll();
    }

    public User getUser(long id) {
        return userRepository.findById(id).get();

    }

    public User updateUser(long id, UpdateUserDto dto) {
        User u = userRepository.findById(id).get();
        if (dto.username().isPresent()) {
            u.setFullName(dto.username().get());
        }
        if (dto.email().isPresent()) {
            u.setEmail(dto.email().get());
        }
        if (dto.password().isPresent()) {
            u.setPasswordHash(encoder.encode(dto.password().get()));
        }
        if (dto.phoneNumber().isPresent()) {
            u.setPhoneNumber(dto.phoneNumber().get());
        }
        if (dto.address().isPresent()) {
            u.setAddress(dto.address().get());
        }
        if (dto.role().isPresent()) {
            u.setRole(dto.role().get());
        }
        if (dto.profileImageUrl().isPresent()) {
            u.setProfileImageUrl(dto.profileImageUrl().get());
        }
        return userRepository.save(u);
    }

    public void deleteUser(long id) {
        userRepository.deleteById(id);
    }

    public boolean loginUser(String username, String password) {
        User user = userRepository.findByFullName(username);
        if (user == null)
            return false;

        return encoder.matches(password, user.getPasswordHash());
    }
    public long count(){
        return userRepository.count();
    }
}
