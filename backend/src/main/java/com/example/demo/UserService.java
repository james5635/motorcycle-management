package com.example.demo;

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

    public long count() {
        return userRepository.count();
    }

    public void save(User u) {
        userRepository.save(u);
    }

    public List<User> getAll() {
        return (List<User>) userRepository.findAll();
    }

    public boolean loginUser(String username, String password) {
        User user = userRepository.findByFullName(username);
        if (user == null)
            return false;

        return encoder.matches(password, user.getPasswordHash());
    }
}
