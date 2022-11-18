// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flap.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DraftFlap _$DraftFlapFromJson(Map<String, dynamic> json) => DraftFlap(
      authorId: json['authorId'] as String,
      previousFlapId: json['previousFlapId'] as String?,
      originalFlapId: json['originalFlapId'] as String?,
      isPromoted: json['isPromoted'] as bool? ?? false,
      content: json['content'] as String,
    );

Map<String, dynamic> _$DraftFlapToJson(DraftFlap instance) => <String, dynamic>{
      'authorId': instance.authorId,
      'previousFlapId': instance.previousFlapId,
      'originalFlapId': instance.originalFlapId,
      'isPromoted': instance.isPromoted,
      'content': instance.content,
    };

Flap _$FlapFromJson(Map<String, dynamic> json) => Flap(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      previousFlapId: json['previousFlapId'] as String?,
      originalFlapId: json['originalFlapId'] as String?,
      isPromoted: json['isPromoted'] as bool? ?? false,
    );

Map<String, dynamic> _$FlapToJson(Flap instance) => <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'previousFlapId': instance.previousFlapId,
      'originalFlapId': instance.originalFlapId,
      'isPromoted': instance.isPromoted,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
    };
