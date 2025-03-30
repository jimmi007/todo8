import 'dart:convert';
import 'dart:core';
import 'package:uuid/uuid.dart';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';


import 'package:flutter/material.dart';

class NoteProvider with ChangeNotifier {
  static const String _noteListKey = 'notelist_key';
  Map<String, Note> _notelist = {};
  Uuid uuid = Uuid();
  // Getter for all notes
  Map<String, Note> get getNotes => {..._notelist};

  // Load notes from SharedPreferences
  Future<void> loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? notesString = prefs.getString(_noteListKey);
    if (notesString != null) {
      try {
        Map<String, dynamic> notesJson = json.decode(notesString);
        _notelist = notesJson.map((key, value) => MapEntry(
              key,
              Note.fromJson(value),
            ));
      } catch (e) {
        print("Error decoding notes: $e");
        _notelist = {}; // Reset on failure
      }
    } else {
      _notelist = {}; // Ensure it's an empty map
    }
    notifyListeners();
  }

  // Add a note
  Future<void> addNote(Note note) async {
    if (note.id.isEmpty) {
      note = Note(
        id: uuid.v4(), // Generate a unique ID if not provided
        title: note.title,
        content: note.content,
        date: note.date,
      );
    }
    _notelist[note.id] = note;
    await _saveNotes();
    notifyListeners();
  }

  // Remove a note
  Future<void> removeNote(String id) async {
    if (_notelist.containsKey(id)) {
      _notelist.remove(id);
      await _saveNotes();
      notifyListeners();
    } else {
      print("Note not found for removal: $id");
    }
  }

  // Find a note by ID
  Note? findNoteById(String id) => _notelist[id];

  // Update a note
  void updateNote(String id, Note updatedNote) {
    if (_notelist.containsKey(id)) {
      _notelist[id] = updatedNote;
      _saveNotes();
      notifyListeners();
    } else {
      print("Note not found for update: $id");
    }
  }

  // Search notes by title or content
  List<Note> searchNotes(String query) {
    return _notelist.values.where((note) {
      return note.title.toLowerCase().contains(query.toLowerCase()) ||
          note.content.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Save notes to SharedPreferences
  Future<void> _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String notesString = json.encode(
      _notelist.map((key, note) => MapEntry(key, note.toJson())),
    );
    await prefs.setString(_noteListKey, notesString);
    notifyListeners();
  }
}

const uuid = Uuid();

// Note class with JSON serialization
class Note with ChangeNotifier {
  final String id;
  final String title;
  final String content;
  final DateTime date;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  String get formattedDate => DateFormat('d/M/y').format(date);

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Store ID in JSON
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'], // Restore ID from storage
      title: json['title'],
      content: json['content'],
      date: DateTime.parse(json['date']),
    );
  }
}
