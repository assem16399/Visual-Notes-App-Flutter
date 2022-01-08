import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '/modules/visual_note_details/visual_note_details_screen.dart';
import '/providers/visual_notes_provider.dart';

import 'white_space.dart';

class VisualNotesListItem extends StatelessWidget {
  const VisualNotesListItem({
    Key? key,
    required this.date,
    required this.title,
    required this.image,
    required this.id,
  }) : super(key: key);

  final int id;
  final String title;
  final Map date;
  final File image;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(VisualNotesDetails.routeName, arguments: id);
      },
      child: Card(
        child: SizedBox(
          child: Row(
            children: [
              SizedBox(
                width: deviceSize.width * 0.22,
                height: double.infinity,
                child: Hero(
                  tag: id,
                  child: Image.file(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const WhiteSpace(isHorizontal: true),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const WhiteSpace(isHorizontal: false),
                  SizedBox(
                    width: title.length < 15 ? null : deviceSize.width * 0.5,
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Text(
                    DateFormat.yMd().format(date['date']),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    date['time'],
                  ),
                ],
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    splashRadius: 20,
                    onPressed: () async {
                      final _deleteConfirmed = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Are You Sure?'),
                          content: const Text(
                            'Do you want to remove this Visual Note, by deleting it '
                            'you won\'t be able to retrieve it again.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const Text('NO'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: const Text('YES'),
                            ),
                          ],
                        ),
                      );
                      if (_deleteConfirmed) {
                        Provider.of<VisualNotesProvider>(context, listen: false)
                            .deleteVisualNote(id);
                      }
                    },
                    icon: const Icon(
                      Icons.delete,
                      size: 30,
                      color: Colors.red,
                    ),
                  )
                ],
              )
            ],
          ),
          width: double.infinity,
          height: isLandscape ? deviceSize.height * 0.25 : deviceSize.height * 0.15,
        ),
      ),
    );
  }
}
