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
      await endpoint.post(RequestContext(), draft);
      return Response.ok('OK');
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
