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

  final List<String> replyIds = [];
  final List<String> reflapIds = [];
  final List<String> likeUserIds = [];

  int get reflapCount => reflapIds.length;
  int get replyCount => replyIds.length;
  int get likeCount => likeUserIds.length;

  User get author => model.userById(authorId);

  bool get isReflap => originalFlapId != null;

  // FIXME: Both of these are hacks to just test the UI.
  bool get wasReflappedByMe => reflapCount > 0;
  bool get wasLikedByMe => likeCount > 0;

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
