import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class Credentials {
  final String username;
  Credentials({required this.username});

  factory Credentials.fromJson(Map<String, dynamic> json) =>
      _$CredentialsFromJson(json);
  Map<String, dynamic> toJson() => _$CredentialsToJson(this);
}

@JsonSerializable()
class AuthResponse {
  final String? sessionId;

  AuthResponse({this.sessionId});

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

// Split user (auth) vs. profile (public) data?
class User {
  final String id;
  final String displayName;
  final String handle;
  final bool official;
  final bool verified;
  final List<String> following;
  final List<String> followers;

  // Good enough hack for now. Remove when we have profile pictures.
  String get initials => displayName.split(' ').map((s) => s[0]).join();

  // FIXME: Not sure where these go?
  final bool hasNewFlaps = false;
  final bool hasNewMessages = false;

  const User({
    required this.id,
    required this.displayName,
    required this.handle,
    this.following = const [],
    this.followers = const [],
    this.official = false,
    this.verified = false,
  });
}
