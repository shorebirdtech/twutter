import 'package:flutter/material.dart';

// Flap has its own style button.
// For now just using an ElevatedButton
class FlapButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  const FlapButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: child);
  }
}
