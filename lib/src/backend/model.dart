import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:twutter/src/model/flap.dart';

class DataStore {
  late Database db;

  Future<void> init() async {
    String dbPath = 'sample.db';
    DatabaseFactory dbFactory = databaseFactoryIo;
    db = await dbFactory.openDatabase(dbPath);
  }

  void createFlap(Flap flap) async {
    var store = stringMapStoreFactory.store('flaps');
    // We generate the flap id outside of the database.
    await store.record(flap.id).add(db, flap.toJson());
  }

  void updateFlap(String flapId, Function(Flap flap) update) async {
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

  void deleteFlap(String flapId) async {
    var store = stringMapStoreFactory.store('flaps');
    await store.record(flapId).delete(db);
  }

  // This should just return a lazy object rather than filling it.
  Future<Timeline> timelineForUser(String userId) async {
    var store = stringMapStoreFactory.store('flaps');
    // Get all Flaps for now.
    var finder = Finder(sortOrders: [SortOrder('createdAt')]);
    var flaps = await store.find(db, finder: finder);
    return Timeline(
        userId, flaps.map((record) => Flap.fromJson(record.value)).toList());
  }
}

var dataStore = DataStore();

class Timeline {
  final String userId;
  final List<Flap> recentFollowedFlaps;

  Timeline(this.userId, this.recentFollowedFlaps);
}

extension LastN<T> on List<T> {
  List<T> lastN(int n) {
    if (n >= length) {
      return this;
    }
    return sublist(length - n);
  }
}
