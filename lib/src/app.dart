import 'package:flutter/material.dart';

import 'gen/client.dart';
import 'screen/home.dart';
import 'screen/login.dart';
import 'view/compose.dart';

class TwutterApp extends StatelessWidget {
  const TwutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ClientBinding(
      initialClient: Client(),
      child: MaterialApp(
        title: 'Twutter',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: ThemeData.dark().appBarTheme.copyWith(
                backgroundColor: Colors.black,
              ),
        ),
        // We shouldn't start at /login.
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginDialog(),
          '/home': (context) => const Home(),
          '/compose': (context) => const ComposeDialog(),
        },
      ),
    );
  }
}
