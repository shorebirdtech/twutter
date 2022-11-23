import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shorebird/shorebird.dart';
import 'package:twutter/src/model/flap.dart';
import 'package:twutter/src/model/user.dart';

class DataStore {
  late Database db;

  DataStore();

  static final DataStore _singleton = DataStore();
  static DataStore get instance => _singleton;

  factory DataStore.of(AuthenticatedContext context) => _singleton;

  Future<void> init() async {
    String dbPath = 'sample.db';
    DatabaseFactory dbFactory = databaseFactoryIo;
    db = await dbFactory.openDatabase(dbPath);
  }

  Future<Flap> flapById(String id) async {
    var store = stringMapStoreFactory.store('flaps');
    var flapRecord = await store.record(id).get(db);
    if (flapRecord == null) {
      throw Exception('Flap not found: $id');
    }
    return Flap.fromJson(flapRecord);
  }

  Future<void> createFlap(Flap flap) async {
    var store = stringMapStoreFactory.store('flaps');
    // We generate the flap id outside of the database.
    await store.record(flap.id).add(db, flap.toJson());
  }

  Future<void> updateFlap(String flapId, Function(Flap flap) update) async {
    await db.transaction((txn) async {
      var store = stringMapStoreFactory.store('flaps');
      var flapJson = await store.record(flapId).get(txn);
      if (flapJson == null) {
        throw "Flap not found";
      }
      var flap = Flap.fromJson(flapJson);
      update(flap);
      await store.record(flapId).put(txn, flap.toJson());
    });
  }

  Future<void> deleteFlap(String flapId) async {
    var store = stringMapStoreFactory.store('flaps');
    await store.record(flapId).delete(db);
  }

  Future<List<Flap>> mostRecentFlaps(int maxFlaps) async {
    var store = stringMapStoreFactory.store('flaps');
    // Get all Flaps for now.
    var finder = Finder(sortOrders: [SortOrder('createdAt')], limit: maxFlaps);
    var flaps = await store.find(db, finder: finder);
    return flaps.map((record) => Flap.fromJson(record.value)).toList();
  }

  Future<User> userById(String userId) async {
    var store = stringMapStoreFactory.store('users');
    var userJson = await store.record(userId).get(db);
    if (userJson == null) {
      throw "User not found";
    }
    return User.fromJson(userJson);
  }

  Future<User> createUser(SignUp signUp) async {
    var store = stringMapStoreFactory.store('users');
    var user = User.fromSignUp(signUp);
    await store.record(user.id).add(db, user.toJson());
    return user;
  }

  // // This should just return a lazy object rather than filling it.
  // Future<Timeline> timelineForUser(String userId) async {
  //   var store = stringMapStoreFactory.store('flaps');
  //   // Get all Flaps for now.
  //   var finder = Finder(sortOrders: [SortOrder('createdAt')]);
  //   var flaps = await store.find(db, finder: finder);
  //   return Timeline(
  //       userId, flaps.map((record) => Flap.fromJson(record.value)).toList());
  // }
}

extension LastN<T> on List<T> {
  List<T> lastN(int n) {
    if (n >= length) {
      return this;
    }
    return sublist(length - n);
  }
}
