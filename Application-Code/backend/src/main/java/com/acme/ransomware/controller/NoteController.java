package com.acme.ransomware.controller;

import com.acme.ransomware.model.Note;
import com.acme.ransomware.service.NoteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/notes")
public class NoteController {

    @Autowired
    private NoteService noteService;

    @PostMapping
    public Note createNote(@RequestBody Note note) {
        return noteService.save(note);
    }

    @GetMapping
    public List<Note> getAllNotes() {
        return noteService.findAll();
    }
}
