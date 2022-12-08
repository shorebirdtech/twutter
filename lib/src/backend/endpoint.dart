import 'package:shorebird/annotations.dart';
import 'package:shorebird/datastore.dart';
import 'package:shorebird/shorebird.dart';
import 'package:twutter/src/model/user.dart';

import "../model/flap.dart";

// Some sort of @InternalEndpoint?
void sendPublishNotifications(ObjectId flapId) {
  // Send notifications to all followers.
  // Send notifications to all users mentioned in the flap.
  // Send notifications to all hashtags mentioned in the flap.

  // When a flap is published, we update all timelines for active users
  // who may be affected by that flap?  All followers?
  // We periodically cull timelines for users beyond a certain size.
}
// Some sort of @InternalEndpoint?
void sendLikeNotifications(ObjectId flapId) {}

@Endpoint()
Future<void> postFlap(AuthenticatedContext context, DraftFlap draft) async {
  // Save the updated draft?
  // Create the flap from the draft.
  var flap = Flap.fromDraft(draft, DateTime.now());
  // Save the flap.
  await DataStore.of(context).collection<Flap>().create(flap);
  // Delete the draft once confirmed?
  // Alert followers of the flap.
  // SendNotificationsEndpoint().sendPublishNotifications(flap.id);
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

// Removed "sinceFlapId" for now since generator doesn't support
// nullable types yet.
@Endpoint()
Future<List<Flap>> timelineLatestFlapsSince(AuthenticatedContext context,
    {int maxCount = 50}) async {
  var flaps = await DataStore.of(context)
      .collection<Flap>()
      .find(where.sortBy('createdAt', descending: true).limit(maxCount))
      .toList();
  // Look for sinceFlapId, if it's not present, assume we only have newer
  // and return maxCount of the most recent Flaps.
  // var lastSeenIndex = flaps.indexWhere((element) => element.id == sinceFlapId);
  // if (lastSeenIndex == -1) {
  return flaps.lastN(maxCount);
  // }
  // return flaps.sublist(
  //     lastSeenIndex + 1, min(lastSeenIndex + maxCount, flaps.length));
}

@Endpoint()
Future<User> userById(AuthenticatedContext context, ObjectId userId) async {
  var user = await DataStore.of(context).collection<User>().byId(userId);
  if (user == null) {
    throw Exception("User not found");
  }
  return user;
}

@Endpoint()
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

@Endpoint()
Future<AuthResponse> login(RequestContext context, AuthRequest request) async {
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
