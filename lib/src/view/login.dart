import 'package:flutter/material.dart';

import '../gen/client.dart';
import '../model/user.dart';
import 'config.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  TextEditingController textController = TextEditingController();

  void closeLoginWindow() {
    // This exists so the async post function doesn't have to hold onto
    // the context object.
    Navigator.of(context).pop();
  }

  void login() async {
    var credentials = Credentials(username: textController.text);
    var result = await client.login(credentials);
    // If success, set me = the userid returned and continue.
    // if failed, show error message, offer to create account?
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(children: [
        const Text("Username:"),
        TextField(
          controller: textController,
          decoration: const InputDecoration(
              border: InputBorder.none, hintText: "Username"),
        ),
      ]),
    );
  }
}
