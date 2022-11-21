import 'package:shorebird/shorebird.dart';
import 'package:twutter/src/model/user.dart';

import "../model/flap.dart";
import 'model.dart';

class SendNotificationsEndpoint extends Endpoint {
  void sendPublishNotifications(String flapId) {
    // Send notifications to all followers.
    // Send notifications to all users mentioned in the flap.
    // Send notifications to all hashtags mentioned in the flap.

    // When a flap is published, we update all timelines for active users
    // who may be affected by that flap?  All followers?
    // We periodically cull timelines for users beyond a certain size.
  }

  void sendLikeNotifications(String flapId) {}
}

class FlapEndpoint extends Endpoint {
  static int _nextFlapId = 0;

  // The datastore should do this, and they won't be monotonoic
  // https://firebase.google.com/docs/firestore/best-practices#hotspots
  String nextFlapId() {
    return (_nextFlapId++).toString();
  }

  // This should probably be a separate endpoint?

  Future<void> post(AuthenticatedContext context, DraftFlap draft) async {
    // Save the updated draft?
    // Create the flap from the draft.
    var flap = Flap.fromDraft(draft, DateTime.now(), nextFlapId());
    // Save the flap.
    await dataStore.createFlap(flap);
    // Delete the draft once confirmed?
    // Alert followers of the flap.
    SendNotificationsEndpoint().sendPublishNotifications(flap.id);
  }

// Like a flap.
// Save the like info on the flap.
// Notify the author of the flap.
  Future<void> like(AuthenticatedContext context, String flapId) async {
    // Save the like info on the flap.
    var session = SessionController.of(context);
    await dataStore.updateFlap(flapId, (flap) {
      flap.likeUserIds.add(session.userId);
    });
    // Notify the author of the flap.
    SendNotificationsEndpoint().sendLikeNotifications(flapId);
  }
}

// For an inactive user becoming active, we rebuild their timeline based
// on their followers.

// This should read from a per-user timeline cache.
// That cache should be generated/updated when a user edits their follows.
// For now we're using a single global timeline cache.
class TimelineEndpoint extends Endpoint {
  // Future<List<Flap>> getTimeline(RequestContext context,
  //     {String? sinceFlapId, int count = 30}) async {
  //   var session = SessionController.of(context);
  //   // This is the wrong API
  //   var timeline = await dataStore.timelineForUser(session.userId);
  //   List<Flap> flaps = timeline.recentFollowedFlaps;
  //   if (sinceFlapId != null) {
  //     var lastSeenIndex =
  //         flaps.indexWhere((element) => element.id == sinceFlapId);
  //     return flaps.sublist(lastSeenIndex + 1, lastSeenIndex + count);
  //   }
  //   // If there is a flap id, look it up.
  //   // If there is no flap id, the latest N flaps.
  //   return flaps.lastN(count);
  // }

  // bool haveFlapsSince(AuthenticatedContext context, String flapId) {
  //   return latestFlapsSince(context, flapId, 1).isNotEmpty;
  // }

  Future<List<Flap>> latestFlapsSince(
      AuthenticatedContext context, String flapId, int maxCount) async {
    // var session = SessionController.of(context);
    // Load the last 100 flaps.
    // Look for the flap id, if it's not present, assume we have newer
    // and return the most recent maxCount.

    const int maxFlaps = 100;
    var flaps = await dataStore.mostRecentFlaps(maxFlaps);
    var lastSeenIndex = flaps.indexWhere((element) => element.id == flapId);
    if (lastSeenIndex == -1) {
      return flaps.lastN(maxCount);
    }
    return flaps.sublist(lastSeenIndex + 1, lastSeenIndex + maxCount);
  }

  // List<Flap> flapsDirectlyAfter(
  //     AuthenticatedContext context, String flapId, int maxCount) {
  //   return <Flap>[];
  // }

  // List<Flap> flapsDirectlyBefore(
  //     AuthenticatedContext context, String flapId, int maxCount) {
  //   return <Flap>[];
  // }
}

class AuthEndpoint extends Endpoint {
  Future<AuthResponse> login(
      RequestContext context, Credentials credentials) async {
    // Get the user from the request.
    // Validate the user.
    // Create a session.
    // Set the session cookie.
    return AuthResponse(
      sessionId: '1',
      user: const User(id: '0', displayName: 'Eric Seidel', handle: '_eseidel'),
    );
  }
}
