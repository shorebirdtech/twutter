import 'dart:async';

import 'package:flutter/material.dart';

import '../gen/client.dart';
import '../model/user.dart';
import '../view/config.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  String? failureMessage;

  void closeLoginWindow() {
    // This exists so the async post function doesn't have to hold onto
    // the context object.
    Navigator.of(context).pushReplacementNamed("/home");
  }

  void loginAs(String name) async {
    var client = Client.of(context);
    var credentials = AuthRequest(username: name);
    var result = await client.actions.login(credentials);
    if (result.success) {
      unawaited(client.actions.refreshTimeline());
      closeLoginWindow();
    } else {
      // if failed, show error message, offer to create account?
      setState(() {
        failureMessage = result.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var knownUsers = ['@dash', '@golddash', '@shorebird', '@flutterdev'];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: LayoutConfig.appBarHeight,
        title: const Text("Login"), // Drafts button
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (failureMessage != null) Text(failureMessage!),
          Wrap(children: [
            for (var user in knownUsers)
              ElevatedButton(
                onPressed: () => loginAs(user),
                child: Text(user),
              ),
          ]),
          const Text("Click on a demo user above to login.")
        ],
      ),
    );
  }
}
