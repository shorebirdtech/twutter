import 'user.dart';
import 'model.dart';

// Retweet or not (can wrap)
// Author line
// Official (only on promoted)
// Content
// Media (or quote tweet)
// View count (only on videos)
// Controls
// "Show this thread" (only on threads)
// Promoted marker (only on promoted)

class DraftFlap {
  final String authorId;
  final String? previousFlapId; // for threads
  final String? originalFlapId; // for retweets
  final bool isPromoted;
  final String content;

  const DraftFlap.compose({required this.authorId, required this.content})
      : isPromoted = false,
        originalFlapId = null,
        previousFlapId = null;

  const DraftFlap.reply(
      {required this.authorId,
      required this.previousFlapId,
      required this.content})
      : isPromoted = false,
        originalFlapId = null;

  const DraftFlap.promoted({required this.authorId, required this.content})
      : isPromoted = true,
        originalFlapId = null,
        previousFlapId = null;

  const DraftFlap.reflap(
      {required this.authorId,
      required this.originalFlapId,
      required this.content})
      : isPromoted = false,
        previousFlapId = null;
}

class Flap {
  final String id; // Only on confirmed flaps?
  final String authorId;
  final String? previousFlapId; // for threads
  final String? originalFlapId; // for retweets
  final bool isPromoted;
  final String content;
  final DateTime createdAt;

  final int replyCount = 0;
  final int reflapCount = 0;
  final int likeCount = 0;

  User get author => model.userById(authorId);

  Flap(
      {required this.id,
      required this.authorId,
      required this.content,
      required this.createdAt,
      this.previousFlapId,
      this.originalFlapId,
      this.isPromoted = false});

  Flap.fromDraft(DraftFlap draft, this.createdAt, this.id)
      : authorId = draft.authorId,
        content = draft.content,
        previousFlapId = draft.previousFlapId,
        originalFlapId = draft.originalFlapId,
        isPromoted = draft.isPromoted;
}
