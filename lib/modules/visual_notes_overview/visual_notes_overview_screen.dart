import 'package:flutter/material.dart';
import 'package:visual_notes_app/modules/edit_visual_note/edit_visual_note_screen.dart';
import 'package:visual_notes_app/shared/components/widgets/visual_notes_list.dart';

class VisualNotesOverviewScreen extends StatelessWidget {
  const VisualNotesOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visual Notes'),
      ),
      body: const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: VisualNotesList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(EditVisualNotesScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
