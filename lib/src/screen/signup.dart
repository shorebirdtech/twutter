import 'package:flutter/material.dart';
import 'package:twutter/src/model/user.dart';

import '../gen/client.dart';
import '../view/config.dart';

class SignUpDialog extends StatefulWidget {
  const SignUpDialog({super.key});

  @override
  State<SignUpDialog> createState() => _SignUpDialogState();
}

class _SignUpDialogState extends State<SignUpDialog> {
  final _formKey = GlobalKey<FormState>();

  String username = '';
  String displayName = '';
  String password = '';

  void closeSignupWindow() {
    // This exists so the async post function doesn't have to hold onto
    // the context object.
    Navigator.of(context).pushReplacementNamed("/home");
  }

  void signUp() async {
    var client = Client.of(context);
    var signUp = SignUp(
      username: username,
      password: password,
      displayName: displayName,
    );
    var result = await client.actions.signUp(signUp);
    if (result.success) {
      closeSignupWindow();
    } else {
      // if failed, show error message.
      // setState(() {
      //   failureMessage = result.error;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: LayoutConfig.appBarHeight,
        title: const Text("Sign-up"),
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
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                filled: true,
                icon: Icon(Icons.person),
                hintText: 'George Washington',
                labelText: 'Name *',
              ),
              onSaved: (String? value) {
                setState(() {
                  displayName = value!;
                });
              },
              validator: (String? value) {
                return value!.contains('@') ? 'Do not use the @ char.' : null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                filled: true,
                icon: Icon(Icons.alternate_email),
                hintText: 'george1789',
                labelText: 'Handle *',
              ),
              onSaved: (String? value) {
                setState(() {
                  username = value!;
                });
              },
              validator: (String? value) {
                return value!.contains('@') ? 'Do not use the @ char.' : null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                filled: true,
                icon: Icon(Icons.lock),
                hintText: 'Your password',
                labelText: 'Password *',
              ),
              onSaved: (String? value) {
                setState(() {
                  password = value!;
                });
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Password cannot be empty.';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                filled: true,
                icon: Icon(Icons.lock),
                hintText: 'Your password',
                labelText: 'Confirm Password *',
              ),
              // onSaved shouldn't be needed since this only checks if
              // the password fields match.
              validator: (String? value) {
                // FIXME: This can't work because the password field
                // hasn't saved yet.
                if (value != password) {
                  return 'Passwords do not match.';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                var state = _formKey.currentState!;
                if (state.validate()) {
                  state.save();
                  signUp();
                }
              },
              child: const Text('Submit'),
            ),
            // Add TextFormFields and ElevatedButton here.
          ],
        ),
      ),
    );
  }
}
