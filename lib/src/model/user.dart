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

class SignUp {
  final String username;
  final String displayName;

  SignUp({required this.username, required this.displayName});
}

@JsonSerializable()
// Split user (auth) vs. profile (public) data?
class User {
  final String id;
  // Mutable with a long time scale component.
  final String displayName;
  final String username;
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
    required this.username,
    this.official = false,
    this.verified = false,
  });

  User.fromSignUp(SignUp signUp)
      : id = '',
        displayName = signUp.displayName,
        username = signUp.username,
        official = false,
        verified = false;

  User copyWith({String? id}) {
    return User(
      id: id ?? this.id,
      displayName: displayName,
      username: username,
      official: official,
      verified: verified,
    );
  }

  const User.empty() : this(id: '', displayName: '', username: '');

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
