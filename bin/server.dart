// This dependency should not exist.
import 'dart:io';

import 'package:shorebird/shorebird.dart';
import 'package:twutter/src/backend/endpoint.dart';
import 'package:twutter/src/backend/model.dart';
import 'package:twutter/src/gen/handlers.dart';

void main() async {
  await DataStore.initSingleton();

  var handlers = <ShorebirdHandler>[
    FlapHandler(FlapEndpoint()),
    AuthHandler(AuthEndpoint()),
    TimelineHandler(TimelineEndpoint()),
    UserHandler(UserEndpoint()),
  ];
  var server = Server();
  await server.serve(handlers, InternetAddress.anyIPv4, 3000);
  // ignore: avoid_print
  print('Serving at http://${server.address.host}:${server.port}');
}
