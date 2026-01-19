package com.example.demo;

import java.util.List;

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

    @GetMapping("/all")
    public List<Customer> getAll() {
        System.out.print(customerService.getAll());
        return customerService.getAll();
    }

    @PostMapping("/save")
    public void save(@RequestBody Customer c) {
        customerService.save(c);
    }

    @PostMapping("/user")
    public void save(@RequestBody User u) {
        userService.save(u);
    }

    @GetMapping("/user")
    public List<User> getAllUser() {
        return userService.getAll();
    }
}
