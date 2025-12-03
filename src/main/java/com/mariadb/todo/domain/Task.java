package com.mariadb.todo.domain;

// 🚨 CORRECTION : Remplacer javax.persistence par jakarta.persistence
import jakarta.persistence.*;

import lombok.Data;

@Data
@Entity
@Table(name = "tasks")
public class Task {
    @Id 
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String description;
    private Boolean completed = false;
}