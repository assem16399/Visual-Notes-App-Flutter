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
    final visualNote = Provider.of<VisualNotesProvider>(context).findVisualNoteById(id);
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
                      child: InteractiveViewer(
                        panEnabled: false,
                        boundaryMargin: const EdgeInsets.all(100),
                        minScale: 0.5,
                        maxScale: 2,
                        child: Hero(
                          tag: visualNote.id!,
                          child: Image.file(visualNote.image!),
                        ),
                      ),
                    ),
                    const WhiteSpace(
                      isHorizontal: false,
                    ),
                    const Title(
                      title: 'Case Description',
                    ),
                    TitleDetails(text: visualNote.description),
                    const WhiteSpace(
                      isHorizontal: false,
                    ),
                    const Title(
                      title: 'Date Taken',
                    ),
                    TitleDetails(text: DateFormat.yMd().format(visualNote.date['date'])),
                    TitleDetails(text: visualNote.date['time']),
                    const WhiteSpace(
                      isHorizontal: false,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Title(
                          title: 'Status',
                        ),
                        const WhiteSpace(
                          isHorizontal: true,
                        ),
                        TitleDetails(text: visualNote.isOpened ? 'Opened' : 'Closed'),
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

class TitleDetails extends StatelessWidget {
  const TitleDetails({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyText2,
    );
  }
}

class Title extends StatelessWidget {
  const Title({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      '$title:',
      style: Theme.of(context).textTheme.bodyText1,
    );
  }
}
