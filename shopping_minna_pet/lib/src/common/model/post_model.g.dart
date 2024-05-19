// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      uuid: json['uuid'] as String?,
      writerUid: json['writerUid'] as String?,
      images: json['images'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'writerUid': instance.writerUid,
      'images': instance.images,
      'title': instance.title,
      'content': instance.content,
      'date': instance.date?.toIso8601String(),
    };
