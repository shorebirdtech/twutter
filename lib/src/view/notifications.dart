import 'package:flutter/material.dart';
import 'package:twutter/src/view/config.dart';

import '../model/model.dart';
import 'notification_group.dart';

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    // Twitter has some fancier text here:
    // https://twitter.com/gojiball/status/1177667000472162304
    return Column(
      children: const [
        Text("Nothing to see here -- yet.",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        Text("When you get notifications, they'll show up here.",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
      ],
    );
  }
}

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: LayoutConfig.timelineWidth,
      child: model.notifications.isEmpty
          ? const _EmptyNotifications()
          : ListView.separated(
              itemBuilder: ((context, index) {
                return NotificationGroupView(
                    notificationGroup: model.notifications[index]);
              }),
              itemCount: model.notifications.length,
              separatorBuilder: (context, index) => const Divider(),
              physics: const AlwaysScrollableScrollPhysics(),
            ),
    );
  }
}
