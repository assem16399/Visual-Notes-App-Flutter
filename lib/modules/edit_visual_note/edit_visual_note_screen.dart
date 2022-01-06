import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:visual_notes_app/models/visual_note.dart';
import 'package:visual_notes_app/providers/visual_notes_provider.dart';
import 'package:visual_notes_app/shared/components/toast.dart';
import 'package:visual_notes_app/shared/components/widgets/image_input.dart';
import 'package:visual_notes_app/shared/components/widgets/white_space.dart';

class EditVisualNotesScreen extends StatefulWidget {
  const EditVisualNotesScreen({Key? key}) : super(key: key);

  static const routeName = '/edit-visual-note';

  @override
  State<EditVisualNotesScreen> createState() => _EditVisualNotesScreenState();
}

class _EditVisualNotesScreenState extends State<EditVisualNotesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  String? _currentStatus;
  final List<String> _statuses = ['Opened', 'Closed'];
  VisualNote? newVisualNote =
      VisualNote(id: null, title: '', description: '', date: {}, isOpened: false, image: null);

  Future<TimeOfDay?> _displayTimePicker(BuildContext context) async {
    return await showTimePicker(context: context, initialTime: TimeOfDay.now());
  }

  Future<DateTime?> _displayDatePicker(BuildContext context) async {
    return await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        lastDate: DateTime.now(),
        firstDate: DateTime(2022));
  }

  void submitForm() {
    if (newVisualNote!.image == null) {
      toast('Please take a picture first.');
      return;
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Provider.of<VisualNotesProvider>(context, listen: false).addVisualNote(newVisualNote!);
    }
  }

  void getImage(File image) {
    newVisualNote = newVisualNote!.copyWith(image: image);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _dateController.dispose();
    _timeController.dispose();
    newVisualNote = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final _isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Visual Note'),
        actions: [IconButton(onPressed: submitForm, icon: const Icon(Icons.check))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ImageInput(
                  getImage: getImage,
                ),
                const WhiteSpace(isHorizontal: false),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter The Title!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    newVisualNote = newVisualNote!.copyWith(title: value);
                  },
                ),
                const WhiteSpace(isHorizontal: false),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Visual Note Description',
                      labelText: 'Description',
                      alignLabelWithHint: true),
                  maxLines: 3,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter The Description!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    newVisualNote = newVisualNote!.copyWith(description: value);
                  },
                ),
                const WhiteSpace(isHorizontal: false),
                Row(
                  children: [
                    SizedBox(
                      width: _isLandscape ? deviceSize.width * 0.4675 : deviceSize.width * 0.449,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) return 'Please Enter The Date. ';
                          return null;
                        },
                        controller: _dateController,
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          newVisualNote!.date['date'] = await _displayDatePicker(context);
                          if (newVisualNote!.date['date'] != null) {
                            _dateController.text =
                                DateFormat.yMd().format(newVisualNote!.date['date']);
                          }
                        },
                        decoration: const InputDecoration(labelText: 'Date'),
                      ),
                    ),
                    const WhiteSpace(isHorizontal: true),
                    SizedBox(
                      width: _isLandscape ? deviceSize.width * 0.4675 : deviceSize.width * 0.449,
                      child: TextFormField(
                        controller: _timeController,
                        validator: (value) {
                          if (value!.isEmpty) return 'Please Enter The Time. ';
                          return null;
                        },
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          newVisualNote!.date['time'] = await _displayTimePicker(context);
                          if (newVisualNote!.date['time'] != null) {
                            _timeController.text = newVisualNote!.date['time'].format(context);
                          }
                        },
                        decoration: const InputDecoration(labelText: 'Time'),
                      ),
                    ),
                  ],
                ),
                const WhiteSpace(isHorizontal: false),
                DropdownButtonFormField<dynamic>(
                  value: _currentStatus,
                  items: [
                    ..._statuses
                        .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                  ],
                  onChanged: (value) {
                    _currentStatus = value.toString();
                  },
                  decoration: const InputDecoration(labelText: 'Current Status'),
                  validator: (value) {
                    if (value == null) {
                      return 'Please Enter The Current Status';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value == 'Opened') {
                      newVisualNote!.isOpened = true;
                    } else {
                      newVisualNote!.isOpened = false;
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
