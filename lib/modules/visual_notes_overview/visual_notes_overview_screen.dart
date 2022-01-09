import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visual_notes_app/modules/edit_visual_note/edit_visual_note_screen.dart';
import 'package:visual_notes_app/providers/visual_notes_provider.dart';
import 'package:visual_notes_app/shared/components/widgets/background_image_container.dart';
import 'package:visual_notes_app/shared/components/widgets/visual_notes_list.dart';

enum FilterOptions {
  showAll,
  opened,
  closed,
}

class VisualNotesOverviewScreen extends StatefulWidget {
  const VisualNotesOverviewScreen({Key? key}) : super(key: key);

  @override
  State<VisualNotesOverviewScreen> createState() =>
      _VisualNotesOverviewScreenState();
}

class _VisualNotesOverviewScreenState extends State<VisualNotesOverviewScreen> {
  Future? _visualNotesFuture;

  Future _obtainVisualNotesFuture() {
    return Provider.of<VisualNotesProvider>(context, listen: false)
        .fetchAndSetVisualNotes();
  }

  @override
  void initState() {
    // TODO: implement initState
    _visualNotesFuture = _obtainVisualNotesFuture();
    super.initState();
  }

  var _selectedFilter = FilterOptions.showAll;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedFilter == FilterOptions.showAll
            ? 'All Visual Notes'
            : _selectedFilter == FilterOptions.opened
                ? 'Opened Visual Notes'
                : 'Closed Visual Notes'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Show All'),
                value: FilterOptions.showAll,
                enabled:
                    _selectedFilter == FilterOptions.showAll ? false : true,
              ),
              PopupMenuItem(
                child: const Text('Shop Opened'),
                value: FilterOptions.opened,
                enabled: _selectedFilter == FilterOptions.opened ? false : true,
              ),
              PopupMenuItem(
                child: const Text('Show Closed'),
                value: FilterOptions.closed,
                enabled: _selectedFilter == FilterOptions.closed ? false : true,
              ),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                _selectedFilter = selectedValue;
              });
            },
          ),
          if (Platform.isIOS)
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditVisualNotesScreen.routeName);
                },
                icon: const Icon(Icons.add))
        ],
      ),
      body: SafeArea(
        child: BackgroundImageContainer(
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
                  return VisualNotesList(
                    selectedFilter: _selectedFilter,
                  );
                }
              },
            ),
          ),
        ),
      ),
      floatingActionButton: Platform.isIOS
          ? SizedBox()
          : FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditVisualNotesScreen.routeName);
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}
