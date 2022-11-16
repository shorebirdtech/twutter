import 'package:flutter/material.dart';

import 'navigation.dart';

class TwutterApp extends StatelessWidget {
  const TwutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twutter',
      theme: ThemeData.dark(),
      home: const RootNavigation(),
    );
  }
}
