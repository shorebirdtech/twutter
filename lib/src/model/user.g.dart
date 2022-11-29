// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRequest _$AuthRequestFromJson(Map<String, dynamic> json) => AuthRequest(
      username: json['username'] as String,
    );

Map<String, dynamic> _$AuthRequestToJson(AuthRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
    };

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
      sessionId: json['sessionId'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'user': instance.user,
    };

SignUp _$SignUpFromJson(Map<String, dynamic> json) => SignUp(
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$SignUpToJson(SignUp instance) => <String, dynamic>{
      'username': instance.username,
      'displayName': instance.displayName,
      'password': instance.password,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: const ObjectIdConverter().fromJson(json['id'] as String),
      displayName: json['displayName'] as String,
      username: json['username'] as String,
      official: json['official'] as bool? ?? false,
      verified: json['verified'] as bool? ?? false,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': const ObjectIdConverter().toJson(instance.id),
      'displayName': instance.displayName,
      'username': instance.username,
      'official': instance.official,
      'verified': instance.verified,
    };
