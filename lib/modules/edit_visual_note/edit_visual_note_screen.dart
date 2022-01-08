import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '/models/visual_note.dart';
import '/providers/visual_notes_provider.dart';
import '/shared/components/toast.dart';
import '/shared/components/widgets/image_input.dart';
import '/shared/components/widgets/white_space.dart';

class EditVisualNotesScreen extends StatefulWidget {
  const EditVisualNotesScreen({Key? key}) : super(key: key);

  static const routeName = '/edit-visual-note';

  @override
  State<EditVisualNotesScreen> createState() => _EditVisualNotesScreenState();
}

class _EditVisualNotesScreenState extends State<EditVisualNotesScreen> {
  final _formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

  var _initialData = {
    'title': '',
    'description': '',
  };

  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  String? _currentStatus;

  final List<String> _statuses = ['Opened', 'Closed'];

  VisualNote? _visualNote =
      VisualNote(id: null, title: '', description: '', date: {}, isOpened: false, image: null);

  void getImage(File image) {
    _visualNote = _visualNote!.copyWith(image: image);
  }

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

  void submitForm() async {
    if (_visualNote!.image == null) {
      toast('Please take a picture first.');
      return;
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_visualNote!.id == null) {
        try {
          await Provider.of<VisualNotesProvider>(context, listen: false)
              .addVisualNote(_visualNote!);
          toast('Added Successfully');
        } catch (error) {
          toast('Something Went Wrong!');
          print(error);
          return;
        }
      } else {
        try {
          await Provider.of<VisualNotesProvider>(context, listen: false)
              .updateExistingNote(_visualNote!.id!, _visualNote!);
          toast('Edited Successfully');
        } catch (error) {
          toast('Something Went Wrong!');
          print(error);
          return;
        }
      }
      Navigator.of(context).pop();
    }
  }

  var _isDidChangeDepCalled = false;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (!_isDidChangeDepCalled) {
      final id = ModalRoute.of(context)!.settings.arguments as int?;
      if (id != null) {
        _visualNote =
            Provider.of<VisualNotesProvider>(context, listen: false).findVisualNoteById(id);
        _initialData = {
          'title': _visualNote!.title,
          'description': _visualNote!.description,
        };
        _dateController.text = DateFormat.yMd().format(_visualNote!.date['date']);
        _timeController.text = _visualNote!.date['time'];
        _currentStatus = _visualNote!.isOpened ? 'Opened' : 'Closed';
      } else {
        _visualNote!.date['date'] = DateTime.now();
        _visualNote!.date['time'] = TimeOfDay.now().format(context);
        _dateController.text = DateFormat.yMd().format(_visualNote!.date['date']);
        _timeController.text = _visualNote!.date['time'];
      }
      _isDidChangeDepCalled = true;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _dateController.dispose();
    _timeController.dispose();
    focusNode.dispose();
    _visualNote = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final _isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: Text(_visualNote!.id == null ? 'Create New Visual Note' : 'Edit Visual Note'),
        actions: [
          IconButton(
            onPressed: submitForm,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Container(
        height: deviceSize.height,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: const AssetImage('assets/images/bg2.jpg'),
            colorFilter: ColorFilter.mode(Colors.transparent.withOpacity(0.2), BlendMode.dstATop),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ImageInput(
                    getImage: getImage,
                    image: _visualNote!.image,
                  ),
                  const WhiteSpace(isHorizontal: false),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: _initialData['title'],
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter The Title!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _visualNote = _visualNote!.copyWith(title: value);
                    },
                  ),
                  const WhiteSpace(isHorizontal: false),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: _initialData['description'],
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
                      _visualNote = _visualNote!.copyWith(description: value);
                    },
                  ),
                  const WhiteSpace(isHorizontal: false),
                  Row(
                    children: [
                      SizedBox(
                        width: _isLandscape ? deviceSize.width * 0.4675 : deviceSize.width * 0.449,
                        child: TextFormField(
                          readOnly: true,
                          showCursor: false,
                          validator: (value) {
                            if (value!.isEmpty) return 'Please Enter The Date.';
                            return null;
                          },
                          controller: _dateController,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(focusNode);

                            final date = await _displayDatePicker(context);
                            if (date != null) {
                              print('date set');
                              _visualNote!.date['date'] = date;
                              _dateController.text = DateFormat.yMd().format(date);
                            }
                          },
                          decoration: const InputDecoration(labelText: 'Date'),
                        ),
                      ),
                      const WhiteSpace(isHorizontal: true),
                      SizedBox(
                        width: _isLandscape ? deviceSize.width * 0.4675 : deviceSize.width * 0.449,
                        child: TextFormField(
                          readOnly: true,
                          showCursor: false,
                          controller: _timeController,
                          validator: (value) {
                            if (value!.isEmpty) return 'Please Enter The Time. ';
                            return null;
                          },
                          onTap: () async {
                            FocusScope.of(context).requestFocus(focusNode);
                            final time = await _displayTimePicker(context);
                            if (time != null) {
                              print('time set');
                              _visualNote!.date['time'] = time.format(context);
                              _timeController.text = time.format(context);
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
                        _visualNote!.isOpened = true;
                      } else {
                        _visualNote!.isOpened = false;
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
