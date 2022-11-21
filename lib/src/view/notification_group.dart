import 'package:flutter/material.dart';
import 'package:twutter/src/model/notification.dart';

import '../model/model.dart';
import 'avatar.dart';
import 'config.dart';
import 'user.dart';

class NotificationGroupView extends StatelessWidget {
  final NotificationGroup notificationGroup;
  const NotificationGroupView({super.key, required this.notificationGroup});

  Widget iconForType(NotificationType type) {
    switch (type) {
      case NotificationType.follow:
        return const Icon(Icons.person_add);
      case NotificationType.mention:
        return const Icon(Icons.alternate_email);
      case NotificationType.retweet:
        return const Icon(Icons.repeat);
      case NotificationType.like:
        return const Icon(Icons.favorite);
      case NotificationType.direct:
        var userId = notificationGroup.notifications.first.userId!;
        return AvatarView(
          user: cache.userById(userId),
          radius: LayoutConfig.avatarRadius,
        );
    }
  }

  // X (and Y others) followed you
// X (and Y others) liked your reply, post, retweet
// X (and Y others) liked a post you were mentioned in
// X liked Y posts you were mentioned in.
// X retweeted a post you were mentioned in
// Direct mention tweet, including "show this thread"

  List<Widget> actionLineActor() {
    var notifications = notificationGroup.notifications;
    var count = notifications.length;
    var firstUser = cache.userById(notifications.first.userId!);
    if (count == 1) {
      return firstUser.verifiedName;
    } else if (count == 2) {
      var secondNotification = notifications[1];
      var secondUser = cache.userById(secondNotification.userId!);
      return [
        ...firstUser.verifiedName,
        const Text(' and '),
        ...secondUser.verifiedName,
      ];
    } else {
      return [
        ...firstUser.verifiedName,
        const Text(' and '),
        Text('${count - 1} others'),
      ];
    }
  }

  String actionLineVerb() {
    var type = notificationGroup.notifications.first.type;
    switch (type) {
      case NotificationType.follow:
        return 'followed';
      case NotificationType.mention:
        return 'mentioned';
      case NotificationType.retweet:
        return 'retweeted';
      case NotificationType.like:
        return 'liked';
      case NotificationType.direct:
        throw "Direct messages don't have a verb";
    }
  }

  String actionLineObject() {
    var notification = notificationGroup.notifications.first;
    var flapId = notification.flapId;
    if (flapId == null) {
      throw "No object for $notification";
    }
    var flap = cache.flapById(flapId);
    // your flap, your reply, a flap you were mentioned in
    if (flap.authorId != cache.userId) {
      return "a flap you were mentioned in";
    } else {
      if (flap.isReply) {
        return "your reply";
      } else {
        // Not sure if reflaps need to be separate or not?
        return "your flap";
      }
    }
  }

  Widget actionLineForGroup() {
    // FIXME: This is not designed for localization.
    return Row(
      children: [
        ...actionLineActor(),
        const Text(' '),
        Text(actionLineVerb()),
        const Text(' '),
        Text(actionLineObject()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Same shape as timeline view.
    // left side is either a user avatar or a notification icon

    var avatarLine = Row(
      children:
          // Up to 7 avatars.
          notificationGroup.notifications.take(7).map((notification) {
        var userId = notification.userId!;
        return AvatarView(
          user: cache.userById(userId),
          radius: LayoutConfig.avatarRadius,
        );
      }).toList(),
    );

    var actionLine = actionLineForGroup();

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: LayoutConfig.timelineHorizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: LayoutConfig.avatarColumnWidth,
            child: iconForType(notificationGroup.type),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                avatarLine,
                actionLine,
                // referenced tweet content in background text.
              ],
            ),
          )
        ],
      ),
    );
  }
}
