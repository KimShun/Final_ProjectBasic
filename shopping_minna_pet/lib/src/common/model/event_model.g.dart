// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
      uuid: json['uuid'] as String?,
      eventImage: json['eventImage'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      eventProgress: json['eventProgress'] as String?,
      userImageAvailable: json['userImageAvailable'] as bool?,
    );

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'eventImage': instance.eventImage,
      'title': instance.title,
      'content': instance.content,
      'date': instance.date?.toIso8601String(),
      'eventProgress': instance.eventProgress,
      'userImageAvailable': instance.userImageAvailable,
    };
