import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shorebird/shorebird.dart';
import 'package:twutter/src/model/flap.dart';
import 'package:twutter/src/model/user.dart';

// FIXME: DataStore should move to package:shorebird.
class DataStore {
  late Db db;

  DataStore();

  static DataStore? _singleton;
  static DataStore get instance => _singleton!;

  factory DataStore.of(AuthenticatedContext context) => _singleton!;

  static Future<void> initSingleton() async {
    _singleton = DataStore();
    await _singleton!.init();
  }

  Future<void> init() async {
    // Specified in digial ocean's environment settings:
    // https://docs.digitalocean.com/products/app-platform/how-to/use-environment-variables/#define-build-time-environment-variables
    final mongoUrl = Platform.environment['DATABASE_URL'];
    if (mongoUrl == null) {
      throw Exception('DATABASE_URL environment variable is not set.');
    }
    db = await Db.create(mongoUrl);
    await db.open();
  }

  Future<void> close() async {
    await db.close();
  }

  Future<Flap> flapById(ObjectId id) async {
    var store = db.collection('flaps');
    var flapJson = await store.findOne(where.id(id));
    if (flapJson == null) {
      throw Exception('Flap not found: $id');
    }
    return Flap.fromDbJson(flapJson);
  }

  Future<Flap> createFlap(Flap flap) async {
    // Should either use a transaction or an ObjectId for this two step process.
    var store = db.collection('flaps');
    var dbJson = flap.toDbJson();
    // insert modifies the dbJson to include _id.
    await store.insert(dbJson);
    return Flap.fromDbJson(dbJson);
  }

  Future<void> updateFlap(ObjectId flapId, Function(Flap flap) callback) async {
    var store = db.collection('flaps');
    var flapJson = await store.findOne(where.id(flapId));
    if (flapJson == null) {
      throw Exception('Flap not found: $flapId');
    }
    var flap = Flap.fromDbJson(flapJson);
    callback(flap);
    flapJson = flap.toDbJson();
    await store.updateOne(where.id(flapId), flapJson);
  }

  Future<void> deleteFlap(ObjectId flapId) async {
    var store = db.collection('flaps');
    await store.deleteOne(where.id(flapId));
  }

  Future<List<Flap>> mostRecentFlaps(int maxFlaps) async {
    var store = db.collection('flaps');
    var flapJsons = await store
        .find(where.sortBy('createdAt', descending: true).limit(maxFlaps))
        .toList();
    return flapJsons.map((flapJson) => Flap.fromDbJson(flapJson)).toList();
  }

  Future<User> userById(ObjectId userId) async {
    var store = db.collection('users');
    var userJson = await store.findOne(where.id(userId));
    if (userJson == null) {
      throw Exception('User not found: $userId');
    }
    return User.fromDbJson(userJson);
  }

  Future<User?> userByUsername(String username) async {
    var store = db.collection('users');
    var userJson = await store.findOne(where.eq('username', username));
    if (userJson == null) {
      return null;
    }
    return User.fromDbJson(userJson);
  }

  Future<User> createUser(User user) async {
    var store = db.collection('users');
    var dbJson = user.toDbJson();
    // insert modifies the dbJson to include _id.
    await store.insert(dbJson);
    return User.fromDbJson(dbJson);
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
