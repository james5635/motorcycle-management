package com.example.demo;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CustomerService {

    @Autowired
    private CustomerRepository customerRepository;

    public void save(Customer c) {
        customerRepository.save(c);
    }
    public List<Customer> getAll(){
        return (List<Customer>) customerRepository.findAll();
    }
}
