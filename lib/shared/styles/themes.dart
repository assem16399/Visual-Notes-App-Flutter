import 'package:flutter/material.dart';

final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple)
        .copyWith(secondary: Colors.deepOrange),
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()));
