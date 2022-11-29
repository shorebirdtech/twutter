import 'dart:math';

import 'package:shorebird/datastore.dart';
import 'package:shorebird/shorebird.dart';
import 'package:twutter/src/model/user.dart';

import "../model/flap.dart";

class SendNotificationsEndpoint extends Endpoint {
  void sendPublishNotifications(ObjectId flapId) {
    // Send notifications to all followers.
    // Send notifications to all users mentioned in the flap.
    // Send notifications to all hashtags mentioned in the flap.

    // When a flap is published, we update all timelines for active users
    // who may be affected by that flap?  All followers?
    // We periodically cull timelines for users beyond a certain size.
  }

  void sendLikeNotifications(ObjectId flapId) {}
}

class FlapEndpoint extends Endpoint {
  Future<void> post(AuthenticatedContext context, DraftFlap draft) async {
    // Save the updated draft?
    // Create the flap from the draft.
    var flap = Flap.fromDraft(draft, DateTime.now());
    // Save the flap.
    await DataStore.of(context).collection<Flap>().create(flap);
    // Delete the draft once confirmed?
    // Alert followers of the flap.
    SendNotificationsEndpoint().sendPublishNotifications(flap.id);
  }
}

// For an inactive user becoming active, we rebuild their timeline based
// on their followers.

extension LastN<T> on List<T> {
  List<T> lastN(int n) {
    if (n >= length) {
      return this;
    }
    return sublist(length - n);
  }
}

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

  Future<bool> haveFlapsSince(
      AuthenticatedContext context, ObjectId flapId) async {
    var flaps =
        await latestFlapsSince(context, sinceFlapId: flapId, maxCount: 1);
    return flaps.isNotEmpty;
  }

  Future<List<Flap>> latestFlapsSince(AuthenticatedContext context,
      {required ObjectId? sinceFlapId, required int maxCount}) async {
    // var session = SessionController.of(context);
    // Load the last 100 flaps.
    // Look for the flap id, if it's not present, assume we have newer
    // and return the most recent maxCount.

    var flaps = await DataStore.of(context)
        .collection<Flap>()
        .find(where.sortBy('createdAt', descending: true).limit(maxCount))
        .toList();
    var lastSeenIndex =
        flaps.indexWhere((element) => element.id == sinceFlapId);
    if (lastSeenIndex == -1) {
      return flaps.lastN(maxCount);
    }
    return flaps.sublist(
        lastSeenIndex + 1, min(lastSeenIndex + maxCount, flaps.length));
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

class UserEndpoint extends Endpoint {
  Future<User> userById(AuthenticatedContext context, ObjectId userId) async {
    var user = await DataStore.of(context).collection<User>().byId(userId);
    if (user == null) {
      throw Exception("User not found");
    }
    return user;
  }

  Future<User> userByUsername(
      AuthenticatedContext context, String username) async {
    var user = await DataStore.of(context)
        .collection<User>()
        .findOne(where.eq('username', username));
    if (user == null) {
      throw Exception("User not found");
    }
    return user;
  }
}

class AuthEndpoint extends Endpoint {
  Future<AuthResponse> login(
      RequestContext context, AuthRequest request) async {
    // Get the user from the request.
    // Validate the user.
    // Create a session.
    // Set the session cookie.
    var user = await DataStore.of(context)
        .collection<User>()
        .findOne(where.eq('username', request.username));
    if (user == null) {
      throw Exception("User not found");
    }
    return AuthResponse(
      sessionId: '1',
      user: user,
    );
  }
}
