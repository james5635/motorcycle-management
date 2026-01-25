package com.example.demo;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HomeController {

    private final CustomerService customerService;
    private final UserService userService;

    @Autowired
    public HomeController(CustomerService customerService, UserService userService) {
        this.customerService = customerService;
        this.userService = userService;
    }

    @GetMapping("/")
    public String index() {
        return "hello world";
    }

    @PostMapping("/user")
    public void saveUser(@RequestBody User u) {
        userService.save(u);
    }

    @GetMapping("/user")
    public List<User> getAllUser() {
        return userService.getAll();
    }

    @PostMapping("/user-login")
    public boolean loginUser(@RequestBody Map<String, String> l) {
        String username = l.get("username");
        String password = l.get("password");
        if ( username == null || password  == null  )
        {
            return false; 
        }
            return userService.loginUser(username, password);
    }
}
