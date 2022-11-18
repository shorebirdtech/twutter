import 'package:twutter/src/model/model.dart';

import 'flap.dart';
import 'user.dart';

var _eric =
    const User(id: '0', displayName: 'Eric Seidel', handle: '@_eseidel');
var _adam =
    const User(id: '1', displayName: 'Adam Barth', handle: '@adambarth');
var _ian = const User(id: '2', displayName: 'Ian Hickson', handle: '@hixie');
var _tim = const User(
    id: '3', displayName: 'Tim Sneath', handle: '@timsneath', verified: true);
var _flutter = const User(
    id: '4',
    displayName: 'Flutter',
    handle: '@flutterdev',
    verified: true,
    official: true);

var demoUsers = [_eric, _adam, _ian, _tim, _flutter];

DateTime _ago({int days = 0, int hours = 0, int minutes = 0}) => DateTime.now()
    .subtract(Duration(days: days, hours: hours, minutes: minutes));

class DummyStoreBuilder {
  int lastId = 0;
  List<Flap> flaps = [];

  Flap flapWithId(String id) => flaps.firstWhere((f) => f.id == id);

  void validate(DraftFlap draft, DateTime createdAt) {
    if (draft.originalFlapId != null) {
      var original = flapWithId(draft.originalFlapId!);
      if (createdAt.isBefore(original.createdAt)) {
        throw ArgumentError('Replies must be newer than the original flap.');
      }
    }
  }

  void addFlap(DraftFlap draft, DateTime createdAt) {
    validate(draft, createdAt);
    var flap = Flap.fromDraft(draft, createdAt, genId());
    flaps.add(flap);
  }

  Flap previousFlap() => flaps.last;
  String genId() => (lastId++).toString();

  void flap(User author, String content, DateTime createdAt) {
    var flap = DraftFlap.compose(
      authorId: author.id,
      content: content,
    );
    addFlap(flap, createdAt);
  }

  void reply(User author, Flap previous, String content, DateTime createdAt) {
    var flap = DraftFlap.reply(
      previousFlapId: previous.id,
      authorId: author.id,
      content: content,
    );
    addFlap(flap, createdAt);
  }

  // Retweets drop promotion status?
  // What happens to a retweet of a retweet?
  void reflap(User author, Flap original, DateTime createdAt) {
    if (createdAt.isBefore(original.createdAt)) {
      throw ArgumentError('Reflaps must be newer than the original flap.');
    }
    var flap = DraftFlap.reflap(
      authorId: author.id,
      originalFlapId: original.id,
      content: original.content,
    );
    addFlap(flap, createdAt);
  }

  ClientDataStore build() {
    var store = ClientDataStore();
    store.me = _eric;
    // Things to test:
    // Retweet or not (can wrap)
    // Author line
    // Official (only on promoted)
    // Content
    // Media (or quote tweet)
    // View count (only on videos)
    // Controls
    // "Show this thread" (only on threads)
    // Promoted marker (only on promoted)
    flap(_adam, "Yo", _ago(hours: 11));
    flap(_ian, "Is this thing on?", _ago(hours: 10));
    reply(_eric, previousFlap(), "Yes, it is.", _ago(hours: 9));
    reply(_tim, previousFlap(), "Yup, here we go!", _ago(hours: 8));
    flap(
        _flutter,
        "Dash is headed to Kenya!  Join us for #FlutterForward, Jan 25, 2023",
        _ago(hours: 9));
    reflap(_eric, previousFlap(), _ago(hours: 4));
    store.latestFlaps = flaps;
    return store;
  }
}
