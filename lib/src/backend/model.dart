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

  Future<Flap> createFlap(Flap flap) async {
    return await db.transaction((txn) async {
      var store = stringMapStoreFactory.store('flaps');
      var id = await store.add(txn, flap.toJson());
      var flapWithId = flap.copyWith(id: id);
      await store.record(id).update(txn, flapWithId.toJson());
      return flapWithId;
    });
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

  Future<User> userByUsername(String username) async {
    var store = stringMapStoreFactory.store('users');
    var finder = Finder(filter: Filter.equals('username', username), limit: 1);
    var users = await store.find(db, finder: finder);
    if (users.isEmpty) {
      throw "User not found";
    }
    return User.fromJson(users.first.value);
  }

  Future<User> createUser(User user) async {
    return await db.transaction((txn) async {
      var store = stringMapStoreFactory.store('users');
      var id = await store.add(txn, user.toJson());
      var withId = user.copyWith(id: id);
      await store.record(id).update(txn, withId.toJson());
      return withId;
    });
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
