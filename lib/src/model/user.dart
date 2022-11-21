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
  final String sessionId;
  final User user;

  AuthResponse({required this.sessionId, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

@JsonSerializable()
// Split user (auth) vs. profile (public) data?
class User {
  final String id;
  // Mutable with a long time scale component.
  final String displayName;
  final String handle;
  final bool official;
  final bool verified;

  // Good enough hack for now. Remove when we have profile pictures.
  String get initials => displayName.split(' ').map((s) => s[0]).join();

  // FIXME: Remove: Mutable and has a time component.
  // final List<String> following;
  // final List<String> followers;

  const User({
    required this.id,
    required this.displayName,
    required this.handle,
    this.official = false,
    this.verified = false,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
