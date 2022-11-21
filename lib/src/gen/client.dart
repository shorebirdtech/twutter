import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:twutter/src/model/flap.dart';
import 'package:twutter/src/model/model.dart';
import 'package:twutter/src/model/user.dart';

enum LoginResult {
  success,
  failure,
}

class Client {
  String? _sessionId;

  // This should come from the connection?
  static const String baseUrl = 'http://localhost:8080';

  Future<http.Response> sessionPost(
      String path, Map<String, dynamic> body) async {
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

  Future<void> publish(DraftFlap draft) async {
    var response = await sessionPost('flaps/post', draft.toJson());
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to publish flap');
    }
  }

  // Future<User> whoAmI() async {
  //   var response = await sessionPost('users/whoami', {});
  //   if (response.statusCode != HttpStatus.ok) {
  //     throw Exception('Failed to get user');
  //   }
  //   return User.fromJson(jsonDecode(response.body));
  // }

  Future<LoginResult> login(Credentials credentials) async {
    // Unclear if this should use post() or not since it sets up the session.
    Uri uri = Uri.parse('$baseUrl/login');
    var response = await http.post(uri, body: credentials.toJson());
    if (response.statusCode != HttpStatus.ok) {
      return LoginResult.failure;
    }
    var resultJson = jsonDecode(response.body);
    var result = AuthResponse.fromJson(resultJson);
    _sessionId = result.sessionId;
    cache.userId = result.userId;
    return LoginResult.success;
  }
}

var client = Client();
