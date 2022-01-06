import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visual_notes_app/shared/styles/colors.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({Key? key, required this.getImage}) : super(key: key);
  final void Function(File image) getImage;

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _takePicture() async {
    final imagePicker = ImagePicker();
    final imageFile = await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });
    widget.getImage(_storedImage!);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final _isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Row(
      children: [
        Container(
          width: _isLandscape ? deviceSize.width * 0.45 : deviceSize.width * 0.5,
          height: _isLandscape ? deviceSize.height * 0.4 : deviceSize.height * 0.15,
          decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: (_storedImage != null)
              ? Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : const Text(
                  'No Image Selected!',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: _isLandscape ? deviceSize.width * 0.15 : deviceSize.width * 0.05,
        ),
        Expanded(
          child: ElevatedButton.icon(
            label: const Text('Take a Picture'),
            icon: const Icon(Icons.camera),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(kSecondaryColor),
            ),
            onPressed: _takePicture,
          ),
        )
      ],
    );
  }
}
