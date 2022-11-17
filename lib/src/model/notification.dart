// X (and Y others) followed you
// X (and Y others) liked your reply, post, retweet
// X (and Y others) liked a post you were mentioned in
// X liked Y posts you were mentioned in.
// X retweeted a post you were mentioned in
// Direct mention tweet, including "show this thread"

enum NotificationType {
  follow,
  like,
  mention,
  retweet,
  direct,
}

class Notification {
  NotificationType type;
  String? flapId;
  String? userId;
  Notification({this.flapId, this.userId, required this.type});
}

class NotificationGroup {
  final NotificationType type;
  final List<Notification> notifications;
  const NotificationGroup(this.type, this.notifications);
}
