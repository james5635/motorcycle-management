package com.example.demo;

import jakarta.persistence.*;

@Entity
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    private int customerId;
    private String name;


    public String getName() {
        return this.name;
    }
}
