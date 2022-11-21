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

  bool isRefreshingTimeline = false;
  bool hasUnreadFlaps = false;
  List<Flap> latestFlaps = [];

  List<NotificationGroup> notifications = [];

  // // Drafts should be persisted to disk?
  // List<DraftFlap> drafts = [];

  bool hasNewMessages = false;
}

// var model = DummyStoreBuilder().build();

// When loading the latest N tweets and K > N behind, twitter will only load N
// but will elide the middle section of the loaded.
class TimelineCache {
  final String userId;
  final DateTime refreshTime;
  final String lastReadFlapId;

  TimelineCache(this.userId, this.refreshTime, this.lastReadFlapId);
}
