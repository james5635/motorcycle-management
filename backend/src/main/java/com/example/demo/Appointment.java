package com.example.demo;

import java.time.LocalDateTime;


import jakarta.persistence.Column;
import jakarta.persistence.Id;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "Appointments")
@Data
public class Appointment {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long appointmentId;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "service_id")
    private Service service;

    private String vehicleDetails;
    private LocalDateTime appointmentDate;
    private String status = "scheduled";
    
    @Column(columnDefinition = "TEXT")
    private String notes;
}