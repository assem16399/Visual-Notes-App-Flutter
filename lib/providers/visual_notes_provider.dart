import 'package:flutter/material.dart';
import 'package:visual_notes_app/models/visual_note.dart';

//this class is considered as your data container (provider)
class VisualNotesProvider with ChangeNotifier {
  // List of Visual Notes
  final List<VisualNote> _visualNotes = [
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

  int _counter = 0;
  void addVisualNote(VisualNote visualNote) {
    _counter++;
    _visualNotes.add(visualNote.copyWith(id: _counter));
    notifyListeners();
  }

  void updateExistingNote(int id, VisualNote editedVisualNote) {
    final editedNoteIndex = _visualNotes.indexWhere((visualNote) => visualNote.id == id);
    _visualNotes[editedNoteIndex] = editedVisualNote;
    notifyListeners();
  }

  void deleteVisualNote(int id) {
    _visualNotes.removeWhere((visualNote) => visualNote.id == id);
    notifyListeners();
  }
}
