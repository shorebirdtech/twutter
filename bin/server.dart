// This dependency should not exist.
import 'package:shorebird/shorebird.dart';
import 'package:twutter/src/backend/endpoint.dart';
import 'package:twutter/src/backend/model.dart';
import 'package:twutter/src/gen/handlers.dart';

void main() async {
  await DataStore.instance.init();

  var handlers = <ShorebirdHandler>[
    FlapHandler(FlapEndpoint()),
    AuthHandler(AuthEndpoint()),
    TimelineHandler(TimelineEndpoint()),
    UserHandler(UserEndpoint()),
  ];
  var server = Server();
  await server.serve(handlers, 'localhost', 8080);
  // ignore: avoid_print
  print('Serving at http://${server.address.host}:${server.port}');
}
