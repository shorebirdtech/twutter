import 'package:flutter/widgets.dart';
import 'package:twutter/src/model/user.dart';

import 'gen/client.dart';
import 'model/model.dart';

// Aiming for simple state management.
// Modeled on https://gist.github.com/HansMuller/29b03fc5e2285957ad7b0d6a58faac35
// From https://medium.com/flutter/managing-flutter-application-state-with-inheritedwidgets-1140452befe1

@immutable
class Store {
  final ClientRoot client;
  final AuthenticatedCache? authenticatedCache;

  const Store()
      : client = const ClientRoot(Connection()),
        authenticatedCache = null;

  static Store of(BuildContext context) {
    final _ModelBindingScope scope =
        context.dependOnInheritedWidgetOfExactType<_ModelBindingScope>()!;
    return scope.modelBindingState.store;
  }

  Actions get actions => Actions(this);

  static void update(BuildContext context, Store newModel) {
    final _ModelBindingScope scope =
        context.dependOnInheritedWidgetOfExactType<_ModelBindingScope>()!;
    scope.modelBindingState.updateModel(newModel);
  }
}

class ModelBinding extends StatefulWidget {
  final Widget child;
  final Store initialStore;

  const ModelBinding(
      {super.key, required this.child, this.initialStore = const Store()});

  @override
  State<ModelBinding> createState() => _ModelBindingState();
}

class _ModelBindingState extends State<ModelBinding> {
  late Store store;

  @override
  void initState() {
    super.initState();
    store = widget.initialStore;
  }

  void updateModel(Store newModel) {
    if (newModel != store) {
      setState(() {
        store = newModel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ModelBindingScope(
      modelBindingState: this,
      child: widget.child,
    );
  }
}

class _ModelBindingScope extends InheritedWidget {
  final Store store;
  final _ModelBindingState modelBindingState;

  const _ModelBindingScope(
      {required this.modelBindingState, required super.child});

  ClientRoot get client => store.client;
  AuthenticatedCache? get authenticatedCache => store.authenticatedCache;

  @override
  bool updateShouldNotify(_ModelBindingScope oldWidget) {
    return true;
    // Would require us to implement equality on Store first.
    // return oldWidget.store != store;
  }
}

class Actions {
  // Not sure where this code should go?
  void authAsUser(AuthResponse auth) {
    store.authenticatedCache = AuthenticatedCache(auth.user);
    client.connection.setSessionId(auth.sessionId);
  }

  // Not sure where this code should go?
  void refreshTimeline() {
    if (store.authenticatedCache == null ||
        store.authenticatedCache!.isRefreshingTimeline) {
      return;
    }
    var cache = store.authenticatedCache!;
    var latestFlapId =
        cache.latestFlaps.isEmpty ? '' : cache.latestFlaps.first.id;
    client.timeline.latestFlapsSince(sinceFlapId: latestFlapId).then((flaps) {
      cache.latestFlaps = flaps;
      cache.isRefreshingTimeline = false;
    }).catchError((e) {
      cache.lastTimelineError = e;
      cache.isRefreshingTimeline = false;
    });
  }
}
