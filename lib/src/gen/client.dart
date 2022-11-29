import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:twutter/src/model/flap.dart';
import 'package:twutter/src/model/user.dart';

// Should this be a package:freezed union type?
class LoginResult {
  bool get success => error == null;
  final String? error;
  final AuthResponse? auth;

  const LoginResult.failure(String this.error) : auth = null;
  const LoginResult.success(AuthResponse this.auth) : error = null;
}

class CachedFlap {
  final Flap flap;
  final User author;
  const CachedFlap(this.flap, this.author);
}

class Client {
  final String baseUrl;
  String? sessionId;
  final ValueNotifier<User?> user = ValueNotifier(null);

  // String lastFetchedFlapId = '';
  final ValueNotifier<List<CachedFlap>> cachedFlaps = ValueNotifier([]);

  Client({this.baseUrl = 'http://localhost:8080'}) : sessionId = null;

  Actions get actions => Actions(this);

  void authAsUser(AuthResponse auth) {
    user.value = auth.user;
    sessionId = auth.sessionId;
  }

  // Should use our own Response type.
  Future<http.Response> post(String path, Map<String, dynamic> body) async {
    var url = Uri.parse('$baseUrl/$path');
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (sessionId != null) {
      headers['X-Session-Id'] = sessionId!;
    }
    return await http
        .post(
          url,
          headers: headers,
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 5));
  }

  static Client of(BuildContext context) {
    final _ClientBindingScope scope =
        context.dependOnInheritedWidgetOfExactType<_ClientBindingScope>()!;
    return scope.clientBindingState.client;
  }

  Future<void> publish(DraftFlap draft) async {
    var response = await post('flap/post', draft.toJson());
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to publish flap');
    }
  }

  Future<List<Flap>> latestFlapsSince(
      {required String sinceFlapId, int maxCount = 50}) async {
    var response = await post('timeline/latestFlapsSince', {
      'sinceFlapId': sinceFlapId,
      'maxCount': maxCount,
    });
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to get latest flaps');
    }
    var json = jsonDecode(response.body);
    return (json as List).map((e) => Flap.fromJson(e)).toList();
  }

  Future<User> userById(mongo.ObjectId userId) async {
    var response = await post('user/userById', {'userId': userId});
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to get user');
    }
    var json = jsonDecode(response.body);
    return User.fromJson(json);
  }

  Future<LoginResult> login(Credentials credentials) async {
    // Unclear if this should use post() or not since it sets up the session.
    var response = await post('login', credentials.toJson());
    if (response.statusCode != HttpStatus.ok) {
      return LoginResult.failure(response.reasonPhrase!);
    }
    var resultJson = jsonDecode(response.body);
    var result = AuthResponse.fromJson(resultJson);
    return LoginResult.success(result);
  }
}

// Modeled on https://gist.github.com/HansMuller/29b03fc5e2285957ad7b0d6a58faac35
// From https://medium.com/flutter/managing-flutter-application-state-with-inheritedwidgets-1140452befe1
class ClientBinding extends StatefulWidget {
  final Widget child;
  final Client initialClient;

  const ClientBinding({
    super.key,
    required this.child,
    required this.initialClient,
  });

  @override
  State<ClientBinding> createState() => _ClientBindingState();
}

class _ClientBindingState extends State<ClientBinding> {
  late Client client;

  @override
  void initState() {
    super.initState();
    client = widget.initialClient;
  }

  // void updateClient(Client newClient) {
  //   if (newClient != client) {
  //     setState(() {
  //       client = newClient;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return _ClientBindingScope(
      clientBindingState: this,
      client: client,
      child: widget.child,
    );
  }
}

class _ClientBindingScope extends InheritedWidget {
  final Client client;
  final _ClientBindingState clientBindingState;

  const _ClientBindingScope({
    required this.clientBindingState,
    required this.client,
    required super.child,
  });

  @override
  bool updateShouldNotify(_ClientBindingScope oldWidget) {
    // If we ever rebuild the ClientBinding, we need to rebuild all listeners.
    return true;
  }
}

// Actions are all supposed to be synchronous functions returning void?
class Actions {
  final Client client;

  Actions(this.client);

  Future<void> publish(DraftFlap draft) async {
    await client.publish(draft);
    // Also cause our timeline to refresh?
  }

  Future<void> refreshTimeline() async {
    var latestFlaps = await client.latestFlapsSince(sinceFlapId: '');
    var flaps = <CachedFlap>[];
    for (var flap in latestFlaps) {
      var author = await client.userById(flap.authorId);
      flaps.add(CachedFlap(flap, author));
    }
    // cachedFlaps should always be kept in reverse chronological order.
    // Later we may need to insert/remove flaps from the sorted list.
    flaps.sort((a, b) => b.flap.createdAt.compareTo(a.flap.createdAt));
    client.cachedFlaps.value = flaps;
  }

  Future<LoginResult> login(Credentials credentials) async {
    var result = await client.login(credentials);
    if (result.success) {
      client.authAsUser(result.auth!);
    }
    return result;
  }
}
