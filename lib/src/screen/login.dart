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
  final _formKey = GlobalKey<FormState>();

  late String username;
  late String password;
  String? failureMessage;

  void closeLoginWindow() {
    // This exists so the async post function doesn't have to hold onto
    // the context object.
    Navigator.of(context).pushReplacementNamed("/home");
  }

  void login() async {
    var client = Client.of(context);
    var credentials = AuthRequest(username: username, password: password);
    var result = await client.actions.login(credentials);
    if (result.success) {
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
      body: Form(
        key: _formKey,
        child: Column(children: [
          const Text("Username:"),
          TextFormField(
            decoration: const InputDecoration(hintText: "e.g. jack"),
            validator: (String? value) {
              if (value != null && value.trim().isEmpty) {
                return 'Username is required';
              }
              return null;
            },
            onSaved: (String? value) {
              setState(() {
                username = value!;
              });
            },
          ),
          const Text("Password:"),
          TextFormField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            validator: (String? value) {
              if (value != null && value.trim().isEmpty) {
                return 'Password is required';
              }
              return null;
            },
            onSaved: (String? value) {
              setState(() {
                password = value!;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              // Validate returns true if the form is valid, or false
              // otherwise.
              var state = _formKey.currentState!;
              if (state.validate()) {
                state.save();
                login();
              }
            },
            child: const Text('Submit'),
          ),
          if (failureMessage != null) Text(failureMessage!),
          const Divider(),
          const Text("New to Twutter?"),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pushNamed("/signup"),
            child: const Text("Sign up"),
          ),
        ]),
      ),
    );
  }
}
