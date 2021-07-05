package com.sample.devops.assignment.controller;

import com.sample.devops.assignment.repository.PersonEntity;

public class PersonMapper {

    public static PersonEntity toEntity(Person person){
        return new PersonEntity(person.getId(), person.getName(), person.getAge());
    }

    public static PersonEntity toEntity(Person person, Long id){
        return new PersonEntity(id, person.getName(), person.getAge());
    }

    public static Person fromEntity(PersonEntity entity){
        return new Person(entity.getId(), entity.getName(), entity.getAge());
    }
}
