import 'flap.dart';
import 'notification.dart';
import 'user.dart';

// Client's view of the datastore?
// Should be per-user.

class AuthenticatedCache {
  User user;
  AuthenticatedCache(this.user) {
    _userCache[user.id] = user;
  }

  final Map<String, User> _userCache = {};
  User? userById(String id) => _userCache[id];

  final Map<String, Flap> _flapCache = {};
  Flap? flapById(String id) => _flapCache[id];

  bool hasNewFlaps = false;
  List<Flap> latestFlaps = [];

  List<NotificationGroup> notifications = [];

  // Drafts should be persisted to disk?
  List<DraftFlap> drafts = [];

  bool hasNewMessages = false;
}

// FIXME: This should not be global, rather an InheritedWidget or similar.
// Callers should check null and use a local (hence the long name).
AuthenticatedCache? authenticatedCache;

// var model = DummyStoreBuilder().build();
