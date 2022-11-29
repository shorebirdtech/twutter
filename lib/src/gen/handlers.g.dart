// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handlers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatestFlapsSinceArgs _$LatestFlapsSinceArgsFromJson(
        Map<String, dynamic> json) =>
    LatestFlapsSinceArgs(
      sinceFlapId: _$JsonConverterFromJson<String, ObjectId>(
          json['sinceFlapId'], const ObjectIdConverter().fromJson),
      maxCount: json['maxCount'] as int? ?? 50,
    );

Map<String, dynamic> _$LatestFlapsSinceArgsToJson(
        LatestFlapsSinceArgs instance) =>
    <String, dynamic>{
      'sinceFlapId': _$JsonConverterToJson<String, ObjectId>(
          instance.sinceFlapId, const ObjectIdConverter().toJson),
      'maxCount': instance.maxCount,
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
