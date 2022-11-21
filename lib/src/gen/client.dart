import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:twutter/src/model/flap.dart';
import 'package:twutter/src/model/model.dart';
import 'package:twutter/src/model/user.dart';

class LoginResult {
  bool get success => error == null;
  final String? error;
  LoginResult({this.error});

  LoginResult.failure(String this.error);
  LoginResult.success() : error = null;
}

class Connection {
  final String baseUrl = 'http://localhost:8080';

  String? _sessionId;

  void setSessionId(String sessionId) {
    _sessionId = sessionId;
  }

  // Should use our own Response type.
  Future<http.Response> post(String path, Map<String, dynamic> body) async {
    var url = Uri.parse('$baseUrl/$path');
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_sessionId != null) {
      headers['X-Session-Id'] = _sessionId!;
    }
    return await http.post(url, headers: headers, body: jsonEncode(body));
  }
}

class Client {
  final Connection connection;
  Client(this.connection);
}

class FlapClient extends Client {
  FlapClient(super.connection);

  Future<void> publish(DraftFlap draft) async {
    var response = await connection.post('flap/post', draft.toJson());
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to publish flap');
    }
  }
}

class AuthClient extends Client {
  AuthClient(super.connection);

  // Future<User> whoAmI() async {
  //   var response = await sessionPost('users/whoami', {});
  //   if (response.statusCode != HttpStatus.ok) {
  //     throw Exception('Failed to get user');
  //   }
  //   return User.fromJson(jsonDecode(response.body));
  // }

  Future<LoginResult> login(Credentials credentials) async {
    // Unclear if this should use post() or not since it sets up the session.
    var response = await connection.post('login', credentials.toJson());
    if (response.statusCode != HttpStatus.ok) {
      return LoginResult.failure(response.reasonPhrase!);
    }
    var resultJson = jsonDecode(response.body);
    var result = AuthResponse.fromJson(resultJson);
    connection.setSessionId(result.sessionId);
    authenticatedCache = AuthenticatedCache(result.user);
    return LoginResult.success();
  }
}

class ClientRoot {
  final Connection connection;
  final FlapClient flap;
  final AuthClient auth;

  ClientRoot(this.connection)
      : flap = FlapClient(connection),
        auth = AuthClient(connection);
}

// FIXME: This should not be global.
var client = ClientRoot(Connection());
