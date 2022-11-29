// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flap.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DraftFlap _$DraftFlapFromJson(Map<String, dynamic> json) => DraftFlap(
      authorId: const ObjectIdConverter().fromJson(json['authorId'] as String),
      previousFlapId: _$JsonConverterFromJson<String, ObjectId>(
          json['previousFlapId'], const ObjectIdConverter().fromJson),
      originalFlapId: _$JsonConverterFromJson<String, ObjectId>(
          json['originalFlapId'], const ObjectIdConverter().fromJson),
      isPromoted: json['isPromoted'] as bool? ?? false,
      content: json['content'] as String,
    );

Map<String, dynamic> _$DraftFlapToJson(DraftFlap instance) => <String, dynamic>{
      'authorId': const ObjectIdConverter().toJson(instance.authorId),
      'previousFlapId': _$JsonConverterToJson<String, ObjectId>(
          instance.previousFlapId, const ObjectIdConverter().toJson),
      'originalFlapId': _$JsonConverterToJson<String, ObjectId>(
          instance.originalFlapId, const ObjectIdConverter().toJson),
      'isPromoted': instance.isPromoted,
      'content': instance.content,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

Flap _$FlapFromJson(Map<String, dynamic> json) => Flap(
      id: const ObjectIdConverter().fromJson(json['id'] as String),
      authorId: const ObjectIdConverter().fromJson(json['authorId'] as String),
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      previousFlapId: _$JsonConverterFromJson<String, ObjectId>(
          json['previousFlapId'], const ObjectIdConverter().fromJson),
      originalFlapId: _$JsonConverterFromJson<String, ObjectId>(
          json['originalFlapId'], const ObjectIdConverter().fromJson),
      isPromoted: json['isPromoted'] as bool? ?? false,
    );

Map<String, dynamic> _$FlapToJson(Flap instance) => <String, dynamic>{
      'id': const ObjectIdConverter().toJson(instance.id),
      'authorId': const ObjectIdConverter().toJson(instance.authorId),
      'previousFlapId': _$JsonConverterToJson<String, ObjectId>(
          instance.previousFlapId, const ObjectIdConverter().toJson),
      'originalFlapId': _$JsonConverterToJson<String, ObjectId>(
          instance.originalFlapId, const ObjectIdConverter().toJson),
      'isPromoted': instance.isPromoted,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
    };
