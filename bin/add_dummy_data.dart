import 'package:shorebird/datastore.dart';
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

  Future<User> userById(ObjectId userId) => _store.userById(userId);
  Future<Flap> flapById(ObjectId flapId) => _store.flapById(flapId);

  Future<Flap> createFlap(Flap flap) async {
    lastFlapCreated = await _store.createFlap(flap);
    return lastFlapCreated!;
  }

  Future<User> createUser(SignUp signUp) =>
      _store.createUser(User.fromSignUp(signUp));

  Flap previousFlap() => lastFlapCreated!;
}

class DummyStoreBuilder {
  final StoreAdaptor store;
  DummyStoreBuilder(this.store);

  Future<Flap> flapWithId(ObjectId id) async => store.flapById(id);

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
    var flap = Flap.fromDraft(draft, createdAt);
    await store.createFlap(flap);
  }

  Flap previousFlap() => store.previousFlap();

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
  Future<void> reflap(User author, Flap original, DateTime createdAt) async {
    if (createdAt.isBefore(original.createdAt)) {
      throw ArgumentError('Reflaps must be newer than the original flap.');
    }
    var flap = DraftFlap.reflap(
      authorId: author.id,
      originalFlapId: original.id,
      content: original.content,
    );
    await addFlap(flap, createdAt);
  }

  Future<void> execute() async {
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
    await reflap(eric, previousFlap(), _ago(hours: 4));
  }
}

void main() async {
  var db = DataStore.instance;
  await db.init();
  var store = StoreAdaptor(db);
  var builder = DummyStoreBuilder(store);
  await builder.execute();
  await db.close();
}
