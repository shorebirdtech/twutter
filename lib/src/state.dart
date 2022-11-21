import 'package:flutter/widgets.dart';
import 'package:twutter/src/model/user.dart';

import 'gen/client.dart';
import 'model/model.dart';

// To launder immutability of StoreState.
class Store {
  final ClientRoot client = ClientRoot(Connection());
  AuthenticatedCache? authenticatedCache;
}

class StoreState extends InheritedWidget {
  final Store store = Store();

  StoreState({super.key, required super.child});

  ClientRoot get client => store.client;
  AuthenticatedCache? get authenticatedCache => store.authenticatedCache;

  static StoreState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StoreState>()!;
  }

  // Not sure where this code should go?
  void authAsUser(AuthResponse auth) {
    store.authenticatedCache = AuthenticatedCache(auth.user);
    client.connection.setSessionId(auth.sessionId);
  }

  @override
  bool updateShouldNotify(StoreState oldWidget) {
    return true;
    // Requires us to implement equality on Store first.
    // return oldWidget.store != store;
  }
}
