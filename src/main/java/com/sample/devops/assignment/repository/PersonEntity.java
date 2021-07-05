package com.sample.devops.assignment.repository;

import javax.persistence.*;

@Entity
@Table(name = "persons")
public class PersonEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true)
    private String name;
    private Integer age;

    public PersonEntity() {
    }

    public PersonEntity(String name, Integer age) {
        this.name = name;
        this.age = age;
    }

    public PersonEntity(Long id, String name, Integer age) {
        this.id = id;
        this.name = name;
        this.age = age;
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public Integer getAge() {
        return age;
    }

}
