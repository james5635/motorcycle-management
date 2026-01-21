package com.example.demo;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public long count() {
        return userRepository.count();
    }

    public void save(User u) {
        userRepository.save(u);
    }

    public List<User> getAll() {
        return (List<User>) userRepository.findAll();
    }
}
