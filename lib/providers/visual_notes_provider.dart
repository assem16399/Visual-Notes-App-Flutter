import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as sys_paths;

import '/models/visual_note.dart';
import '/shared/network/local/db_helper.dart';

//this class is considered as your data container (provider)
class VisualNotesProvider with ChangeNotifier {
  // List of Visual Notes
  List<VisualNote> _visualNotes = [];

  // Getter method to return a clone of the visual notes list to avoid privacy leaks
  List<VisualNote> get visualNotes {
    return [..._visualNotes];
  }

  List<VisualNote> get openedVisualNotes {
    return _visualNotes.where((visualNote) => visualNote.isOpened).toList();
  }

  List<VisualNote> get closedVisualNotes {
    return _visualNotes.where((visualNote) => !visualNote.isOpened).toList();
  }

  VisualNote findVisualNoteById(int id) {
    return _visualNotes.firstWhere((visualNote) => visualNote.id == id);
  }

  Future<void> fetchAndSetVisualNotes() async {
    try {
      final appDir = await sys_paths.getApplicationDocumentsDirectory();

      final extractedData = await DBHelper.getData('visual_notes');
      if (extractedData.isEmpty) return;
      _visualNotes = extractedData
          .map(
            (visualNote) => VisualNote(
                id: visualNote['id'],
                title: visualNote['title'],
                image: File('${appDir.path}/${visualNote['image']}'),
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
      final appDir = await sys_paths.getApplicationDocumentsDirectory();
      final id = await DBHelper.insert('visual_notes', {
        'image': visualNote.image!.path
            .substring(appDir.path.length, visualNote.image!.path.length),
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

  Future<void> updateExistingNote(int id, VisualNote editedVisualNote) async {
    try {
      final appDir = await sys_paths.getApplicationDocumentsDirectory();
      await DBHelper.update(
          'visual_notes',
          {
            'image': editedVisualNote.image!.path.substring(
                appDir.path.length, editedVisualNote.image!.path.length),
            'title': editedVisualNote.title,
            'description': editedVisualNote.description,
            'date': editedVisualNote.date['date'].toIso8601String(),
            'time': editedVisualNote.date['time'],
            'status': editedVisualNote.isOpened ? 1 : 0
          },
          id);
      final editedNoteIndex =
          _visualNotes.indexWhere((visualNote) => visualNote.id == id);
      _visualNotes[editedNoteIndex] = editedVisualNote;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  void deleteVisualNote(int id) {
    _visualNotes.removeWhere((visualNote) => visualNote.id == id);
    notifyListeners();
    DBHelper.delete('visual_notes', id);
  }
}
