import 'package:flutter/material.dart';

class AppDesign {
  const AppDesign._();

  static const double padding = 8.0;
  static const double radius = 12;

  static TextTheme textTheme(BuildContext context) =>
      Theme.of(context).textTheme;
}
