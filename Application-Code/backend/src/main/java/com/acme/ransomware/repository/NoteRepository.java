package com.acme.ransomware.repository;

import com.acme.ransomware.model.Note;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface NoteRepository extends JpaRepository<Note, Long> {
    // Additional query methods can be defined here if needed
}
