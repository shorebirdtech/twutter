import 'package:flutter/material.dart';
import 'package:twutter/src/view/avatar.dart';
import '../model/flap.dart';
import 'config.dart';
import 'theme.dart';

class FlapControl extends StatelessWidget {
  static const double controlsSize = 12;

  final IconData iconData;
  final int? count;
  final VoidCallback? onPressed;

  const FlapControl(
      {super.key, required this.iconData, this.count, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        iconData,
        size: controlsSize,
        color: TwutterTheme.backgroundIconColor(context),
      ),
    );
  }
}

class FlapView extends StatelessWidget {
  final Flap flap;

  static const double checkmarkSize = 12;

  const FlapView({super.key, required this.flap});

  String timeSince(DateTime time) {
    var since = DateTime.now().difference(time);
    if (since.inDays > 0) {
      return '${since.inDays}d';
    } else if (since.inHours > 0) {
      return '${since.inHours}h';
    } else if (since.inMinutes > 0) {
      return '${since.inMinutes}m';
    } else {
      return '${since.inSeconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    var authorLine = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          flap.author.displayName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        if (flap.author.verified) const Text(' '),
        if (flap.author.verified)
          const Icon(
            Icons.check_circle,
            size: checkmarkSize,
            color: Colors.blue,
          ),
        const Text(' '),
        Text(
          flap.author.handle,
          style: TwutterTheme.backgroundText(context),
        ),
        const Text(' \u2022 '),
        Text(
          timeSince(flap.createdAt),
          style: TwutterTheme.backgroundText(context),
        ),
      ],
    );

    var controls = Row(children: [
      FlapControl(iconData: Icons.chat_bubble_outline, count: flap.replyCount),
      FlapControl(iconData: Icons.repeat, count: flap.reflapCount),
      FlapControl(iconData: Icons.favorite_border, count: flap.likeCount),
      const FlapControl(iconData: Icons.share),
    ]);

    // Retweet or not (can wrap)
    // Author line
    // Official (only on promoted)
    // Content
    // Media (or quote tweet)
    // View count (only on videos)
    // Controls
    // "Show this thread" (only on threads)
    // Promoted marker (only on promoted)

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: LayoutConfig.timelineHorizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: LayoutConfig.avatarColumnWidth,
            child: AvatarView(
              user: flap.author,
              radius: LayoutConfig.avatarRadius,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                authorLine,
                Text(flap.content),
                controls,
              ],
            ),
          )
        ],
      ),
    );
  }
}