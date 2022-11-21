import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'flap.g.dart';

// Retweet or not (can wrap)
// Author line
// Official (only on promoted)
// Content
// Media (or quote tweet)
// View count (only on videos)
// Controls
// "Show this thread" (only on threads)
// Promoted marker (only on promoted)

// Can this just be combined into Flap?
// e.g. annotate which things with Flap?
@JsonSerializable()
class DraftFlap {
  final String authorId;
  final String? previousFlapId; // for threads
  final String? originalFlapId; // for retweets
  final bool isPromoted;
  final String content;

  const DraftFlap({
    required this.authorId,
    this.previousFlapId,
    this.originalFlapId,
    this.isPromoted = false,
    required this.content,
  });

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

  factory DraftFlap.fromJson(Map<String, dynamic> json) =>
      _$DraftFlapFromJson(json);

  Map<String, dynamic> toJson() => _$DraftFlapToJson(this);
}

@JsonSerializable()
@immutable
class Flap {
  final String id; // Only on confirmed flaps?
  final String authorId;
  final String? previousFlapId; // for threads
  final String? originalFlapId; // for retweets
  final bool isPromoted;
  final String content;
  final DateTime createdAt;

  // These are mutable and require a query time.  Should be acccessors
  // with a time component?
  // These should not be lists, rather iterators that know their length.
  final List<String> replyIds = [];
  final List<String> reflapIds = [];
  final List<String> likeUserIds = [];

  int get reflapCount => reflapIds.length;
  int get replyCount => replyIds.length;
  int get likeCount => likeUserIds.length;

  bool get isReflap => originalFlapId != null;
  bool get isReply => previousFlapId != null;

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

  factory Flap.fromJson(Map<String, dynamic> json) => _$FlapFromJson(json);

  Map<String, dynamic> toJson() => _$FlapToJson(this);
}
