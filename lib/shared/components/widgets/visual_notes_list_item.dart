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
    required this.id,
  }) : super(key: key);

  final int id;
  final String title;
  final Map date;

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
                child: Image.asset(
                  'assets/images/chair.png',
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const WhiteSpace(isHorizontal: false),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    DateFormat.yMd().format(date['date']),
                  ),
                  Text(
                    date['time'].format(context),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListItemIcon(
                    iconData: Icons.chair,
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
      onPressed: onPressed,
      icon: Icon(
        iconData,
        size: 30,
        color: color,
      ),
    );
  }
}
