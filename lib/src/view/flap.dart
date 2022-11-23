import 'package:flutter/material.dart';
import 'package:twutter/src/gen/client.dart';
import 'package:twutter/src/view/avatar.dart';

import 'config.dart';
import 'theme.dart';
import 'user.dart';

class FlapControl extends StatelessWidget {
  static const double controlsSize = 12;

  final IconData iconData;
  final int? count;
  final VoidCallback onPressed;
  final bool highlighted;

  const FlapControl({
    super.key,
    required this.iconData,
    this.count,
    required this.onPressed,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    var leftAlignHack = const Text("      ");
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        iconData,
        size: controlsSize,
        color: TwutterTheme.backgroundIconColor(context),
      ),
      // Alignment hack.
      label: (count ?? 0) > 0 ? Text("$count") : leftAlignHack,
    );
  }
}

class FlapView extends StatelessWidget {
  final CachedFlap cachedFlap;

  const FlapView({super.key, required this.cachedFlap});

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
    // Flap should come with the User pre-loaded, or at least partially.
    var flap = cachedFlap.flap;
    var author = cachedFlap.author;
    var authorLine = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ...author.verifiedName,
        const Text(' '),
        Text(
          author.handle,
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
      FlapControl(
        iconData: Icons.chat_bubble_outline,
        count: flap.replyCount,
        // Replies never highlight.
        onPressed: () => {},
      ),
      FlapControl(
        iconData: Icons.repeat,
        count: flap.reflapCount,
        highlighted: flap.wasReflappedByMe,
        onPressed: () => {},
      ),
      FlapControl(
        iconData: Icons.favorite_border,
        count: flap.likeCount,
        highlighted: flap.wasLikedByMe,
        onPressed: () => {},
      ),
      FlapControl(iconData: Icons.share, onPressed: () => {}),
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
      child: Column(
        children: [
          if (flap.isReflap)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: LayoutConfig.avatarColumnWidth -
                      LayoutConfig.avatarRightPadding,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.repeat, size: LayoutConfig.checkmarkSize),
                  ),
                ),
                const SizedBox(width: LayoutConfig.avatarRightPadding),
                Text(
                  '${author.displayName} Reflapped',
                  style: TwutterTheme.backgroundText(context),
                ),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: LayoutConfig.avatarColumnWidth,
                child: AvatarView(
                  user: author,
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
        ],
      ),
    );
  }
}
