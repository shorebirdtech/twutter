import '../model/user.dart';
import 'package:flutter/material.dart';
import 'config.dart';

extension UserView on User {
  List<Widget> get verifiedName {
    return [
      Text(
        displayName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      if (verified) const Text(' '),
      if (verified)
        const Icon(
          Icons.check_circle,
          size: LayoutConfig.checkmarkSize,
          color: Colors.blue,
        )
    ];
  }
}
