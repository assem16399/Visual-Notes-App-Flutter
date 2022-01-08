import 'package:flutter/material.dart';

import 'colors.dart';

final lightTheme = ThemeData(
    fontFamily: 'RobotoCondensed',
    colorScheme: ColorScheme.fromSwatch(primarySwatch: kPrimarySwatchColor)
        .copyWith(secondary: kSecondaryColor),
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
    textTheme: const TextTheme(
      bodyText1: TextStyle(fontSize: 25, color: Colors.black),
      bodyText2: TextStyle(fontSize: 16, color: Colors.grey),
    ));
