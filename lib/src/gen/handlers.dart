import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shorebird/shorebird.dart';
import 'package:twutter/src/backend/endpoint.dart';

import '../model/flap.dart';
import '../model/user.dart';

class FlapHandler extends ShorebirdHandler {
  final FlapEndpoint endpoint;

  FlapHandler(this.endpoint);

  @override
  void addRoutes(Router router) {
    router.post('/flap/post', (Request request) async {
      // verify session
      var draftJson = jsonDecode(await request.readAsString());
      var draft = DraftFlap.fromJson(draftJson);
      await endpoint.post(AuthenticatedContext(), draft);
      return Response.ok('OK');
    });
  }
}

class TimelineHandler extends ShorebirdHandler {
  final TimelineEndpoint endpoint;

  TimelineHandler(this.endpoint);

  @override
  void addRoutes(Router router) {
    router.post('/timeline/latestFlapsSince', (Request request) async {
      // verify session
      var argsJson = jsonDecode(await request.readAsString());
      var flaps = await endpoint.latestFlapsSince(AuthenticatedContext(),
          sinceFlapId: argsJson['sinceFlapId'], maxCount: argsJson['maxCount']);
      return Response.ok(jsonEncode(flaps));
    });
  }
}

class UserHandler extends ShorebirdHandler {
  final UserEndpoint endpoint;

  UserHandler(this.endpoint);

  @override
  void addRoutes(Router router) {
    router.post('/user/userById', (Request request) async {
      // verify session
      var argsJson = jsonDecode(await request.readAsString());
      var user = await endpoint.userById(
        AuthenticatedContext(),
        argsJson['userId'],
      );
      return Response.ok(jsonEncode(user));
    });
    router.post('/user/userByUsername', (Request request) async {
      // verify session
      var argsJson = jsonDecode(await request.readAsString());
      var user = await endpoint.userByUsername(
        AuthenticatedContext(),
        argsJson['username'],
      );
      return Response.ok(jsonEncode(user));
    });
  }
}

class AuthHandler extends ShorebirdHandler {
  final AuthEndpoint endpoint;

  AuthHandler(this.endpoint);

  @override
  void addRoutes(Router router) {
    router.post('/login', (Request request) async {
      var credentialsJson = jsonDecode(await request.readAsString());
      var credentials = Credentials.fromJson(credentialsJson);
      var result = await endpoint.login(RequestContext(), credentials);
      return Response.ok(jsonEncode(result.toJson()));
    });
  }
}
