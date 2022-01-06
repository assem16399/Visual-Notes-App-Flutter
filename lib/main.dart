import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visual_notes_app/modules/edit_visual_note/edit_visual_note_screen.dart';
import 'package:visual_notes_app/modules/visual_note_details/visual_note_details_screen.dart';
import 'package:visual_notes_app/providers/visual_notes_provider.dart';
import 'package:visual_notes_app/shared/styles/themes.dart';
import 'modules/visual_notes_overview/visual_notes_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VisualNotesProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: lightTheme,
        home: const VisualNotesOverviewScreen(),
        routes: {
          VisualNotesDetails.routeName: (context) => const VisualNotesDetails(),
          EditVisualNotesScreen.routeName: (context) => const EditVisualNotesScreen(),
        },
      ),
    );
  }
}
