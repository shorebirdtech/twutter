// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Credentials _$CredentialsFromJson(Map<String, dynamic> json) => Credentials(
      username: json['username'] as String,
    );

Map<String, dynamic> _$CredentialsToJson(Credentials instance) =>
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
