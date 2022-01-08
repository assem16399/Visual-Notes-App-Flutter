import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visual_notes_app/providers/visual_notes_provider.dart';
import 'package:visual_notes_app/shared/components/widgets/visual_notes_list_item.dart';

class VisualNotesList extends StatelessWidget {
  const VisualNotesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('visual notes list is building');
    // Assign a listener to the visual notes provider
    final visualNotesProvider = Provider.of<VisualNotesProvider>(context);

    final visualNotes = visualNotesProvider.visualNotes;
    return visualNotes.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Start Adding Some Notes',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  '📷📓',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          )
        : ListView.separated(
            separatorBuilder: (context, _) => const Divider(),
            itemCount: visualNotes.length,
            itemBuilder: (context, index) => VisualNotesListItem(
              id: visualNotes[index].id!,
              title: visualNotes[index].title,
              date: visualNotes[index].date,
              image: visualNotes[index].image!,
            ),
          );
  }
}
