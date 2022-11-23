import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
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

@immutable
class Connection {
  final String baseUrl;
  final String? sessionId;

  const Connection({this.baseUrl = 'http://localhost:8080', this.sessionId});

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
    return await http.post(url, headers: headers, body: jsonEncode(body));
  }

  Connection copyWith({String? sessionId}) {
    return Connection(baseUrl: baseUrl, sessionId: sessionId);
  }
}

@immutable
class Client {
  final Connection connection;
  const Client(this.connection);
}

extension FlapClient on Connection {
  Future<void> publish(DraftFlap draft) async {
    var response = await post('flap/post', draft.toJson());
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to publish flap');
    }
  }
}

extension TimelineClient on Connection {
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
}

extension AuthClient on Connection {
  // Future<User> whoAmI() async {
  //   var response = await sessionPost('users/whoami', {});
  //   if (response.statusCode != HttpStatus.ok) {
  //     throw Exception('Failed to get user');
  //   }
  //   return User.fromJson(jsonDecode(response.body));
  // }

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
