import 'package:flutter/material.dart';

import 'colors.dart';

final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch(primarySwatch: kPrimarySwatchColor)
        .copyWith(secondary: kSecondaryColor),
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()));
