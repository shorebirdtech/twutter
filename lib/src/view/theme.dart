import 'package:flutter/material.dart';

class TwutterTheme {
  static Color backgroundIconColor(BuildContext context) {
    return Theme.of(context).textTheme.caption!.color!;
  }

  static TextStyle backgroundText(BuildContext context) {
    return Theme.of(context).textTheme.caption!;
  }
}
