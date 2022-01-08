import 'dart:io';

class VisualNote {
  final int? id;

  final String title;

  final File? image;

  final String description;

  final Map<String, dynamic> date;

  bool isOpened;

  VisualNote({
    this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.date,
    required this.isOpened,
  });

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
