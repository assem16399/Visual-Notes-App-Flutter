import 'dart:io';

import 'package:flutter/material.dart';
import 'package:visual_notes_app/models/visual_note.dart';
import 'package:visual_notes_app/shared/network/local/db_helper.dart';

//this class is considered as your data container (provider)
class VisualNotesProvider with ChangeNotifier {
  // List of Visual Notes
  List<VisualNote> _visualNotes = [
    // VisualNote(
    //     id: 1,
    //     title: 'Visual Note Sample 1',
    //     image: null,
    //     description: 'short description 1',
    //     date: {'date': DateTime.now(), 'time': TimeOfDay.now()},
    //     isOpened: true),
    // VisualNote(
    //     id: 2,
    //     title: 'Visual Note Sample 2',
    //     image: null,
    //     description: 'This should be a very long description for the visual note sample 2 to be '
    //         'displayed in only one line',
    //     date: {
    //       'date': DateTime.now(),
    //       'time': TimeOfDay.now(),
    //     },
    //     isOpened: false),
  ];

  // Getter method to return a clone of the visual notes list to avoid privacy leaks
  List<VisualNote> get visualNotes {
    return [..._visualNotes];
  }

  VisualNote findVisualNoteById(int id) {
    return _visualNotes.firstWhere((visualNote) => visualNote.id == id);
  }

  Future<void> fetchAndSetVisualNotes() async {
    try {
      final extractedData = await DBHelper.getData('visual_notes');
      _visualNotes = extractedData
          .map(
            (visualNote) => VisualNote(
                id: visualNote['id'],
                title: visualNote['title'],
                image: File(visualNote['image']),
                description: visualNote['description'],
                date: {
                  'date': DateTime.parse(visualNote['date']),
                  'time': visualNote['time'],
                },
                isOpened: visualNote['status'] == 0 ? false : true),
          )
          .toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addVisualNote(VisualNote visualNote) async {
    try {
      final id = await DBHelper.insert('visual_notes', {
        'image': visualNote.image!.path,
        'title': visualNote.title,
        'description': visualNote.description,
        'date': visualNote.date['date'].toIso8601String(),
        'time': visualNote.date['time'],
        'status': visualNote.isOpened ? 1 : 0
      });
      _visualNotes.add(visualNote.copyWith(id: id));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  void updateExistingNote(int id, VisualNote editedVisualNote) {
    final editedNoteIndex = _visualNotes.indexWhere((visualNote) => visualNote.id == id);
    _visualNotes[editedNoteIndex] = editedVisualNote;
    notifyListeners();
    DBHelper.update(
        'visual_notes',
        {
          'image': editedVisualNote.image!.path,
          'title': editedVisualNote.title,
          'description': editedVisualNote.description,
          'date': editedVisualNote.date['date'].toIso8601String(),
          'time': editedVisualNote.date['time'],
          'status': editedVisualNote.isOpened ? 1 : 0
        },
        id);
  }

  void deleteVisualNote(int id) {
    _visualNotes.removeWhere((visualNote) => visualNote.id == id);
    notifyListeners();
    DBHelper.delete('visual_notes', id);
  }
}
