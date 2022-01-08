import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visual_notes_app/modules/edit_visual_note/edit_visual_note_screen.dart';
import 'package:visual_notes_app/providers/visual_notes_provider.dart';
import 'package:visual_notes_app/shared/components/widgets/background_image_container.dart';
import 'package:visual_notes_app/shared/components/widgets/visual_notes_list.dart';

class VisualNotesOverviewScreen extends StatefulWidget {
  const VisualNotesOverviewScreen({Key? key}) : super(key: key);

  @override
  State<VisualNotesOverviewScreen> createState() => _VisualNotesOverviewScreenState();
}

class _VisualNotesOverviewScreenState extends State<VisualNotesOverviewScreen> {
  Future? _visualNotesFuture;

  Future _obtainVisualNotesFuture() {
    return Provider.of<VisualNotesProvider>(context, listen: false).fetchAndSetVisualNotes();
  }

  @override
  void initState() {
    // TODO: implement initState
    _visualNotesFuture = _obtainVisualNotesFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visual Notes'),
      ),
      body: BackgroundImageContainer(
        image: 'assets/images/chair.jpg',
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: _visualNotesFuture,
            builder: (context, dataSnapShoot) {
              if (dataSnapShoot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (dataSnapShoot.hasError) {
                return const Center(
                  child: Text('Something Went Wrong!'),
                );
              } else {
                return const VisualNotesList();
              }
            },
          ),
        ),
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
