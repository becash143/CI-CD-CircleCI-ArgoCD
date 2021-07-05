package com.sample.devops.assignment.controller;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotEmpty;

public class Person {

    private final Long id;

    @NotEmpty
    private final String name;

    @Min(1)
    private final int age;

    public Person(Long id, @NotEmpty String name, @Min(1) int age) {
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

    public int getAge() {
        return age;
    }
}
