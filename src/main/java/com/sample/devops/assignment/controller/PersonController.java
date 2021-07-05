package com.sample.devops.assignment.controller;

import com.sample.devops.assignment.repository.PersonEntity;
import com.sample.devops.assignment.repository.PersonRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import javax.validation.Valid;
import java.util.Optional;

@RestController
@RequestMapping("/persons")
public class PersonController {

    private static final Logger LOGGER = LoggerFactory.getLogger(PersonController.class);

    public PersonController(PersonRepository repository) {
        this.repository = repository;
    }

    private final PersonRepository repository;

    @PostMapping("/")
    public ResponseEntity<?> create(@RequestBody @Valid Person person, UriComponentsBuilder builder) {
        LOGGER.info("received a request to create a person");
        PersonEntity entity = repository.save(PersonMapper.toEntity(person));
        UriComponents uriComponents = builder.path("/persons/{id}").buildAndExpand(entity.getId());
        return ResponseEntity.created(uriComponents.toUri()).body(person.getName());
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable Long id, @RequestBody @Valid Person person) {
        LOGGER.info("received a request to update a person");
        Optional<PersonEntity> existingEntity = repository.findById(id);
        if (!existingEntity.isPresent())
            return ResponseEntity.notFound().build();
        if (person.getId() != null && !id.equals(person.getId()))
            return ResponseEntity.badRequest().body("Ids mismatch");
        repository.save(PersonMapper.toEntity(person, id));
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        LOGGER.info("received a request to delete a person");
        Optional<PersonEntity> existingEntity = repository.findById(id);
        if (!existingEntity.isPresent())
            return ResponseEntity.notFound().build();
        repository.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/")
    public ResponseEntity<Page<Person>> list(@PageableDefault Pageable pageable) {
        LOGGER.info("received a request to list persons");
        return ResponseEntity.ok(repository.findAll(pageable)
                .map(PersonMapper::fromEntity));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Person> get(@PathVariable Long id) {
        LOGGER.info("received a request to retrieve a person");
        Optional<PersonEntity> result = repository.findById(id);
        if (!result.isPresent())
            return ResponseEntity.notFound().build();
        return ResponseEntity.ok(PersonMapper.fromEntity(result.get()));
    }
}
