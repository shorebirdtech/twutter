// Generated by `dart run shorebird generate`.
import 'dart:core';

import 'package:shorebird/datastore.dart';
import 'package:shorebird/shorebird.dart';
import 'package:twutter/src/model/flap.dart';
import 'package:twutter/src/model/user.dart';

import 'handlers.dart';

export 'package:shorebird/shorebird.dart' show Client;

extension HandlerExtensions on Client {
  Future<void> postFlap(DraftFlap draft) {
    final body = PostFlapArgs(draft).toJson();
    return post(
      '/postFlap',
      body,
    );
  }

  Future<List<Flap>> timelineLatestFlapsSince({int maxCount = 50}) {
    final body = TimelineLatestFlapsSinceArgs(maxCount: maxCount).toJson();
    return post(
      '/timelineLatestFlapsSince',
      body,
    ).then(extractResponse<List>).then((e) {
      return e.map<Flap>((e) {
        return Flap.fromJson(e);
      }).toList();
    });
  }

  Future<User> userById(ObjectId userId) {
    final body = UserByIdArgs(userId).toJson();
    return post(
      '/userById',
      body,
    ).then(extractResponse<Map<String, dynamic>>).then((e) {
      return User.fromJson(e);
    });
  }

  Future<User> userByUsername(String username) {
    final body = UserByUsernameArgs(username).toJson();
    return post(
      '/userByUsername',
      body,
    ).then(extractResponse<Map<String, dynamic>>).then((e) {
      return User.fromJson(e);
    });
  }

  Future<AuthResponse> login(AuthRequest request) {
    final body = LoginArgs(request).toJson();
    return post(
      '/login',
      body,
    ).then(extractResponse<Map<String, dynamic>>).then((e) {
      return AuthResponse.fromJson(e);
    });
  }
}
