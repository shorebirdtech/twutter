import 'package:flutter/material.dart';
import 'package:twutter/src/model/flap.dart';

import 'config.dart';
import 'button.dart';
import '../model/model.dart';
import '../gen/client.dart';

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
            onPressed: () {
              var draft = DraftFlap.compose(
                authorId: model.me!.id,
                content: textController.text,
              );
              client.publish(draft);
              // Validate the draft.
              // Send to the server.
              // Wait for response?
              // Close the dialog.
              Navigator.of(context).pop();
            },
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
