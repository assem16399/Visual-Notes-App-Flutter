import 'dart:io';

class VisualNote {
  //visual note id
  final int? id;

  //visual note title
  final String title;

  //visual note taken image;
  final File? image;

  //Visual note description
  final String description;

  //the date and time when the visual note taken
  final Map<String, dynamic> date;

  //Visual note current status
  bool isOpened;

  //constructor to fill the visual
  VisualNote({
    this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.date,
    required this.isOpened,
  });

  // copyWith method to create a deep copy
  VisualNote copyWith({
    int? id,
    String? title,
    File? image,
    String? description,
    Map<String, dynamic>? date,
    final bool? isOpened,
  }) {
    return VisualNote(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      description: description ?? this.description,
      date: date ?? this.date,
      isOpened: isOpened ?? this.isOpened,
    );
  }
}
