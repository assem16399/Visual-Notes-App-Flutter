import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:visual_notes_app/modules/visual_note_details/visual_note_details_screen.dart';
import 'package:visual_notes_app/providers/visual_notes_provider.dart';

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
    //device size
    final deviceSize = MediaQuery.of(context).size;
    // device
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
                child: Image.file(
                  image,
                  fit: BoxFit.cover,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListItemIcon(
                    iconData: Icons.chair,
                    color: Colors.deepPurple,
                    onPressed: () {},
                  ),
                  ListItemIcon(
                    iconData: Icons.delete,
                    onPressed: () {
                      Provider.of<VisualNotesProvider>(context, listen: false).deleteVisualNote(id);
                    },
                    color: Colors.red,
                  ),
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

class ListItemIcon extends StatelessWidget {
  const ListItemIcon({Key? key, required this.iconData, required this.onPressed, this.color})
      : super(key: key);
  final IconData iconData;
  final Color? color;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 20,
      onPressed: onPressed,
      icon: Icon(
        iconData,
        size: 30,
        color: color,
      ),
    );
  }
}
