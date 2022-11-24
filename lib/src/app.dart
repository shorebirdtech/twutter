import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'gen/client.dart';
import 'screen/home.dart';
import 'screen/login.dart';
import 'view/compose.dart';

class TwutterApp extends StatelessWidget {
  const TwutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    // FIXME: This is a hack, should come from an environment variable?
    var url = 'http://localhost:3000';
    if (kReleaseMode) {
      // Production uses a route proxy instead of a custom port.
      url = 'https://${Uri.base.host}/api';
      // e.g. 'wss://shimmer-c3juc.ondigitalocean.app/api'
    }

    return ClientBinding(
      initialClient: Client(baseUrl: url),
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
