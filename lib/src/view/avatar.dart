import 'package:flutter/material.dart';

import '../model/user.dart';

class AvatarView extends StatelessWidget {
  final User user;
  final double? radius;
  const AvatarView({super.key, required this.user, this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.brown.shade800,
      radius: radius,
      child: Text(user.initials),
    );
  }
}
