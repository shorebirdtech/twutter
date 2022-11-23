import 'package:twutter/src/backend/model.dart';
import 'package:twutter/src/model/flap.dart';
import 'package:twutter/src/model/user.dart';

DateTime _ago({int days = 0, int hours = 0, int minutes = 0}) => DateTime.now()
    .subtract(Duration(days: days, hours: hours, minutes: minutes));

// I have a dream that DummyStoreBuilder should work for the client cache too.
class StoreAdaptor {
  final DataStore _store;
  StoreAdaptor(this._store);

  Flap? lastFlapCreated;

  Future<User> userById(String userId) => _store.userById(userId);
  Future<Flap> flapById(String flapId) => _store.flapById(flapId);

  Future<void> createFlap(Flap flap) async {
    await _store.createFlap(flap);
    lastFlapCreated = flap;
  }

  Future<User> createUser(SignUp signUp) => _store.createUser(signUp);

  Flap previousFlap() => lastFlapCreated!;
}

class DummyStoreBuilder {
  final StoreAdaptor store;
  DummyStoreBuilder(this.store);

  int lastId = 0;

  Future<Flap> flapWithId(String id) async => store.flapById(id);

  Future<User> createUser(String displayName, String username,
      {bool isVerified = false, bool isOfficial = false}) async {
    var signUp = SignUp(displayName: displayName, username: username);
    return await store.createUser(signUp);
  }

  void validate(DraftFlap draft, DateTime createdAt) async {
    if (draft.originalFlapId != null) {
      var original = await flapWithId(draft.originalFlapId!);
      if (createdAt.isBefore(original.createdAt)) {
        throw ArgumentError('Replies must be newer than the original flap.');
      }
    }
  }

  Future<void> addFlap(DraftFlap draft, DateTime createdAt) async {
    validate(draft, createdAt);
    var flap = Flap.fromDraft(draft, createdAt, genId());
    await store.createFlap(flap);
  }

  Flap previousFlap() => store.previousFlap();
  String genId() => (lastId++).toString();

  Future<void> flap(User author, String content, DateTime createdAt) async {
    var flap = DraftFlap.compose(
      authorId: author.id,
      content: content,
    );
    await addFlap(flap, createdAt);
  }

  Future<void> reply(
      User author, Flap previous, String content, DateTime createdAt) async {
    var flap = DraftFlap.reply(
      previousFlapId: previous.id,
      authorId: author.id,
      content: content,
    );
    await addFlap(flap, createdAt);
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

  Future<void> build() async {
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

    var dash = await createUser('Dash', '@dash');
    var gold = await createUser('Golden Dash', '@golddash');
    var eric = await createUser('Eric Seidel', '@eseidel', isVerified: true);
    var shorebird = await createUser('Shorebird', '@shorebird',
        isVerified: true, isOfficial: true);
    var flutter = await createUser('Flutter', '@flutterdev',
        isVerified: true, isOfficial: true);

    await flap(dash, "Yo", _ago(hours: 11));
    await flap(shorebird, "Is this thing on?", _ago(hours: 10));
    await reply(eric, previousFlap(), "Yes, it is.", _ago(hours: 9));
    await reply(gold, previousFlap(), "Yup, here we go!", _ago(hours: 8));
    await flap(
        flutter,
        "Dash is headed to Kenya!  Join us for #FlutterForward, Jan 25, 2023",
        _ago(hours: 9));
    reflap(eric, previousFlap(), _ago(hours: 4));
  }
}

void main() async {
  var db = DataStore.instance;
  await db.init();
  var store = StoreAdaptor(db);
  var builder = DummyStoreBuilder(store);
  await builder.build();
}