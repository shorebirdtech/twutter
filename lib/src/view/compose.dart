import 'package:flutter/material.dart';
import 'package:twutter/src/model/flap.dart';

import '../gen/client.dart';
import '../model/model.dart';
import 'button.dart';
import 'config.dart';

class ComposeDialog extends StatefulWidget {
  const ComposeDialog({super.key});

  @override
  State<ComposeDialog> createState() => _ComposeDialogState();
}

// @ brings up user selection
// # brings up hashtag selection.

class _ComposeDialogState extends State<ComposeDialog> {
  TextEditingController textController = TextEditingController();

  // This should have some sort of handle to a draft object
  // which can be saved locally and separately synced to the server.
  // And then finally published?

  void closeComposeWindow() {
    // This exists so the async post function doesn't have to hold onto
    // the context object.
    Navigator.of(context).pop();
  }

  void post() async {
    var draft = DraftFlap.compose(
      authorId: model.me!.id,
      content: textController.text,
    );
    // Immediately disable the publish button?
    // Show a spinner? (Or maybe timeout so short it doesn't matter?)
    // Validate the draft.
    // Send to the server.
    try {
      await client.publish(draft);
      closeComposeWindow();
    } catch (e) {
      // Show an error message.
      // FIXME: This dialog doesn't work yet.
      var result = await showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Flap not sent'),
          content: const Text(
              "We're sorry, we weren't able to send your Flap. Would you like to retry or save this Flap in drafts?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Go to drafts'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Retry'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: LayoutConfig.appBarHeight,
        leading: TextButton(
            // FIXME: Cancel ends up wraping, we may need a custom AppBar.
            // Or just remove the
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context)
                .pop()), // Decide what logged out behavior is?
        title: const Text("Compose"), // Drafts button
        actions: [
          FlapButton(
            onPressed: post,
            child: const Text("Flap"),
          )
        ],
        centerTitle: true,
      ),
      body: TextField(
        controller: textController,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
            border: InputBorder.none, hintText: "What's flapping?"),
        maxLines: null,
        maxLength: 256,
      ),
      // Twitter has a very fancy character counter that counts down from 256.
    );
  }
}
