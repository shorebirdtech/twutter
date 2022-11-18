import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shorebird/shorebird.dart';
import 'package:twutter/src/backend/endpoint.dart';

import '../model/flap.dart';

class FlapHandler extends ShorebirdHandler {
  final FlapEndpoint endpoint;

  FlapHandler(this.endpoint);

  @override
  void addRoutes(Router router) {
    router.post('/flaps/publish', (Request request) async {
      // verify session
      var draftJson = jsonDecode(await request.readAsString());
      var draft = DraftFlap.fromJson(draftJson);
      await endpoint.publish(RequestContext(), draft);
    });
  }
}
