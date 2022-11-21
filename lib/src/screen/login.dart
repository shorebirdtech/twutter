import 'package:flutter/material.dart';

import '../model/user.dart';
import '../state.dart';
import '../view/config.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  TextEditingController textController = TextEditingController();
  String? failureMessage;

  void closeLoginWindow() {
    // This exists so the async post function doesn't have to hold onto
    // the context object.
    Navigator.of(context).pushReplacementNamed("/home");
  }

  void login() async {
    var store = StoreState.of(context);
    var credentials = Credentials(username: textController.text);
    var result = await store.client.auth.login(credentials);
    if (result.success) {
      store.authAsUser(result.auth!);
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
          onSubmitted: (_) => login(),
        ),
        if (failureMessage != null) Text(failureMessage!),
      ]),
    );
  }
}
