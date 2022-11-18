import 'dummy_data.dart';
import 'flap.dart';
import 'notification.dart';
import 'user.dart';

// Client's view of the datastore?  Needs caching.
class ClientDataStore {
  // Authenticated user.
  User? me;

  // FIXME: make async?  This should use an endpoint?
  User userById(String id) => demoUsers.firstWhere((u) => u.id == id);
  // FIXME: This is wrong, this needs to go to a FlapCache or something?
  Flap flapById(String id) => latestFlaps.firstWhere((f) => f.id == id);

  // Client caches.
  List<Flap> latestFlaps = [];
  List<NotificationGroup> notifications = [];
  // Drafts should be persisted to disk?
  List<DraftFlap> drafts = [];
}

var model = DummyStoreBuilder().build();
