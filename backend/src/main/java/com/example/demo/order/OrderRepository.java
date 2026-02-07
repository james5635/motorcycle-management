package com.example.demo.order;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.user.User;

import java.util.List;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {

    // findAllByUserId => finalByUserId
    // find...By... => findBy...
    List<Order> findByUser(User user);
}
