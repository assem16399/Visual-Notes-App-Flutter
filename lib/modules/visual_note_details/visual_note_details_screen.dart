import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:visual_notes_app/modules/edit_visual_note/edit_visual_note_screen.dart';
import '/providers/visual_notes_provider.dart';
import '/shared/components/widgets/white_space.dart';

class VisualNotesDetails extends StatelessWidget {
  const VisualNotesDetails({Key? key}) : super(key: key);
  static const routeName = '/visual-note-details';
  @override
  Widget build(BuildContext context) {
    // visual note Id
    final id = ModalRoute.of(context)!.settings.arguments as int;
    //visual note data of that id
    final visualNote =
        Provider.of<VisualNotesProvider>(context, listen: false).findVisualNoteById(id);
    //device size
    final deviceSize = MediaQuery.of(context).size;
    //device orientation
    final bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: Text(visualNote.title),
      ),
      body: isLandscape
          ? Container()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: deviceSize.height * 0.35,
                      child: visualNote.image == null
                          ? Image.asset('assets/images/chair.png')
                          : Image.file(visualNote.image!),
                    ),
                    const WhiteSpace(
                      isHorizontal: false,
                    ),
                    const DetailsTitle(
                      title: 'Case Description',
                    ),
                    Text(
                      visualNote.description,
                    ),
                    const WhiteSpace(
                      isHorizontal: false,
                    ),
                    const DetailsTitle(
                      title: 'Date Taken',
                    ),
                    Text(
                      DateFormat.yMd().format(visualNote.date['date']),
                    ),
                    Text(
                      visualNote.date['time'],
                    ),
                    const WhiteSpace(
                      isHorizontal: false,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const DetailsTitle(
                          title: 'Status',
                        ),
                        const WhiteSpace(
                          isHorizontal: true,
                        ),
                        Text(
                          visualNote.isOpened ? 'Opened' : 'Closed',
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(EditVisualNotesScreen.routeName, arguments: id);
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}

class DetailsTitle extends StatelessWidget {
  const DetailsTitle({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      '$title:',
      style: Theme.of(context).textTheme.headline6,
    );
  }
}
