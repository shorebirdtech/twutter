import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shorebird/datastore.dart';
import 'package:shorebird/shorebird.dart';
import 'package:twutter/src/backend/endpoint.dart';

import '../model/flap.dart';
import '../model/user.dart';

part 'handlers.g.dart';

var allHandlers = <ShorebirdHandler>[
  FlapHandler(FlapEndpoint()),
  AuthHandler(AuthEndpoint()),
  TimelineHandler(TimelineEndpoint()),
  UserHandler(UserEndpoint()),
];

class FlapHandler extends ShorebirdHandler {
  final FlapEndpoint endpoint;

  FlapHandler(this.endpoint);

  @override
  void collectRoutes(Router router) {
    router.addRoute('/flap/post', (shelf.Request request) async {
      // verify session
      var draftJson = jsonDecode(await request.readAsString());
      var draft = DraftFlap.fromJson(draftJson);
      await endpoint.post(AuthenticatedContext(), draft);
      return shelf.Response.ok('OK');
    });
  }
}

@JsonSerializable()
@ObjectIdConverter()
class LatestFlapsSinceArgs {
  final ObjectId? sinceFlapId;
  final int maxCount;

  LatestFlapsSinceArgs({this.sinceFlapId, this.maxCount = 50});

  factory LatestFlapsSinceArgs.fromJson(Map<String, dynamic> json) =>
      _$LatestFlapsSinceArgsFromJson(json);
  Map<String, dynamic> toJson() => _$LatestFlapsSinceArgsToJson(this);
}

class TimelineHandler extends ShorebirdHandler {
  final TimelineEndpoint endpoint;

  TimelineHandler(this.endpoint);

  @override
  void collectRoutes(Router router) {
    router.addRoute('/timeline/latestFlapsSince',
        (shelf.Request request) async {
      // verify session
      var argsJson = jsonDecode(await request.readAsString());
      var args = LatestFlapsSinceArgs.fromJson(argsJson);
      var flaps = await endpoint.latestFlapsSince(AuthenticatedContext(),
          sinceFlapId: args.sinceFlapId, maxCount: args.maxCount);
      return shelf.Response.ok(jsonEncode(flaps));
    });
  }
}

class UserHandler extends ShorebirdHandler {
  final UserEndpoint endpoint;

  UserHandler(this.endpoint);

  @override
  void collectRoutes(Router router) {
    router.addRoute('/user/userById', (shelf.Request request) async {
      // verify session
      var argsJson = jsonDecode(await request.readAsString());
      var user = await endpoint.userById(
        AuthenticatedContext(),
        const ObjectIdConverter().fromJson(argsJson['userId']),
      );
      return shelf.Response.ok(jsonEncode(user));
    });
    router.addRoute('/user/userByUsername', (shelf.Request request) async {
      // verify session
      var argsJson = jsonDecode(await request.readAsString());
      var user = await endpoint.userByUsername(
        AuthenticatedContext(),
        argsJson['username'],
      );
      return shelf.Response.ok(jsonEncode(user));
    });
  }
}

class AuthHandler extends ShorebirdHandler {
  final AuthEndpoint endpoint;

  AuthHandler(this.endpoint);

  @override
  void collectRoutes(Router router) {
    router.addRoute('/login', (shelf.Request request) async {
      var credentialsJson = jsonDecode(await request.readAsString());
      var credentials = AuthRequest.fromJson(credentialsJson);
      try {
        var result = await endpoint.login(RequestContext(), credentials);
        return shelf.Response.ok(jsonEncode(result.toJson()));
      } catch (e) {
        return shelf.Response(500, body: "Invalid credentials.");
      }
    });
  }
}
