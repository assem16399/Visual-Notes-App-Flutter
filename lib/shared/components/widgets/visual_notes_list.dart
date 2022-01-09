import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visual_notes_app/modules/visual_notes_overview/visual_notes_overview_screen.dart';

import '/providers/visual_notes_provider.dart';
import '/shared/components/widgets/visual_notes_list_item.dart';

class VisualNotesList extends StatelessWidget {
  const VisualNotesList({Key? key, required this.selectedFilter})
      : super(key: key);

  final FilterOptions selectedFilter;
  @override
  Widget build(BuildContext context) {
    final visualNotesProvider = Provider.of<VisualNotesProvider>(context);

    final visualNotes = selectedFilter == FilterOptions.showAll
        ? visualNotesProvider.visualNotes
        : selectedFilter == FilterOptions.opened
            ? visualNotesProvider.openedVisualNotes
            : visualNotesProvider.closedVisualNotes;
    return visualNotes.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  selectedFilter == FilterOptions.showAll
                      ? 'Start Adding Some Notes'
                      : selectedFilter == FilterOptions.opened
                          ? 'You Don\'t Have Any Opened Notes'
                          : 'You Don\'t Have Any Closed Notes',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
                if (selectedFilter == FilterOptions.showAll)
                  Text(
                    '📷📓',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
              ],
            ),
          )
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
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
