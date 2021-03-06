import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void toast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

Future<TimeOfDay?> displayTimePicker(BuildContext context) async {
  return await showTimePicker(context: context, initialTime: TimeOfDay.now());
}

Future<DateTime?> displayDatePicker(BuildContext context) async {
  return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      lastDate: DateTime.now(),
      firstDate: DateTime(2022));
}
