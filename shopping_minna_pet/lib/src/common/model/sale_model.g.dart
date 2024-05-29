// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleModel _$SaleModelFromJson(Map<String, dynamic> json) => SaleModel(
      uuid: json['uuid'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      saleImages: (json['saleImages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SaleModelToJson(SaleModel instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'title': instance.title,
      'content': instance.content,
      'saleImages': instance.saleImages,
    };
