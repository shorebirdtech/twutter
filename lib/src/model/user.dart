import 'package:json_annotation/json_annotation.dart';
import 'package:shorebird/datastore.dart';

part 'user.g.dart';

// Stored separately from User so passwords aren't passed around.
@JsonSerializable()
@ObjectIdConverter()
class AuthEntry {
  final ObjectId id;
  final String username;
  final String password;
  AuthEntry({required this.id, required this.username, required this.password});

  factory AuthEntry.fromJson(Map<String, dynamic> json) =>
      _$AuthEntryFromJson(json);
  Map<String, dynamic> toJson() => _$AuthEntryToJson(this);
}

@JsonSerializable()
class AuthRequest {
  final String username;
  final String password;
  AuthRequest({required this.username, required this.password});

  factory AuthRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AuthRequestToJson(this);
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
class SignUp {
  final String username;
  final String displayName;
  final String password;

  SignUp({
    required this.username,
    required this.displayName,
    required this.password,
  });
  factory SignUp.fromJson(Map<String, dynamic> json) => _$SignUpFromJson(json);
  Map<String, dynamic> toJson() => _$SignUpToJson(this);
}

@JsonSerializable()
@ObjectIdConverter()
// Split user (auth) vs. profile (public) data?
class User {
  final ObjectId id;
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
      : id = ObjectId(),
        displayName = signUp.displayName,
        username = signUp.username,
        official = false,
        verified = false;

  User.empty() : this(id: ObjectId(), displayName: '', username: '');

  factory User.fromDbJson(Map<String, dynamic> json) =>
      User.fromJson(DbJsonConverter.fromDbJson(json));

  Map<String, dynamic> toDbJson() => DbJsonConverter.toDbJson(toJson());

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
