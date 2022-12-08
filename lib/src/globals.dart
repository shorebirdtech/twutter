import 'package:flutter/cupertino.dart';
import 'package:twutter/src/model/flap.dart';
import 'package:twutter/src/model/user.dart';

import 'gen/client.dart';

class Globals {
  final Client client;
  final ValueNotifier<User?> user = ValueNotifier(null);
  final ValueNotifier<List<CachedFlap>> cachedFlaps = ValueNotifier([]);

  Globals({required String baseUrl}) : client = Client(baseUrl: baseUrl);

  Actions get actions => Actions(this);

  void authAsUser(AuthResponse auth) {
    user.value = auth.user;
    client.sessionId = auth.sessionId;
  }

  static Globals of(BuildContext context) {
    final _GlobalsBindingScope scope =
        context.dependOnInheritedWidgetOfExactType<_GlobalsBindingScope>()!;
    return scope.globalsBindingState.globals;
  }
}

class CachedFlap {
  final Flap flap;
  final User author;
  const CachedFlap(this.flap, this.author);
}

// Modeled on https://gist.github.com/HansMuller/29b03fc5e2285957ad7b0d6a58faac35
// From https://medium.com/flutter/managing-flutter-application-state-with-inheritedwidgets-1140452befe1
class GlobalsBinding extends StatefulWidget {
  final Widget child;
  final Globals initialGlobals;

  const GlobalsBinding({
    super.key,
    required this.child,
    required this.initialGlobals,
  });

  @override
  State<GlobalsBinding> createState() => _GlobalsBindingState();
}

class _GlobalsBindingState extends State<GlobalsBinding> {
  late Globals globals;

  @override
  void initState() {
    super.initState();
    globals = widget.initialGlobals;
  }

  // void updateGlobals(Globals newGlobals) {
  //   if (newGlobals != globals) {
  //     setState(() {
  //       globals = newGlobals;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return _GlobalsBindingScope(
      globalsBindingState: this,
      globals: globals,
      child: widget.child,
    );
  }
}

class _GlobalsBindingScope extends InheritedWidget {
  final Globals globals;
  final _GlobalsBindingState globalsBindingState;

  const _GlobalsBindingScope({
    required this.globalsBindingState,
    required this.globals,
    required super.child,
  });

  @override
  bool updateShouldNotify(_GlobalsBindingScope oldWidget) {
    // If we ever rebuild the GlobalsBinding, we need to rebuild all listeners.
    return true;
  }
}

// Actions are all supposed to be synchronous functions returning void?
class Actions {
  final Globals globals;
  Client get client => globals.client;

  Actions(this.globals);

  Future<void> publish(DraftFlap draft) async {
    await client.postFlap(draft);
    // Also cause our timeline to refresh?
  }

  Future<void> refreshTimeline() async {
    var latestFlaps = await client.timelineLatestFlapsSince();
    var flaps = <CachedFlap>[];
    for (var flap in latestFlaps) {
      var author = await client.userById(flap.authorId);
      flaps.add(CachedFlap(flap, author));
    }
    // cachedFlaps should always be kept in reverse chronological order.
    // Later we may need to insert/remove flaps from the sorted list.
    flaps.sort((a, b) => b.flap.createdAt.compareTo(a.flap.createdAt));
    globals.cachedFlaps.value = flaps;
  }

  Future<AuthResponse> login(AuthRequest credentials) async {
    var response = await client.login(credentials);
    globals.authAsUser(response);
    return response;
  }
}
