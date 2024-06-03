// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      uid: json['uid'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      profile: json['profile'] as String?,
      discription: json['discription'] as String?,
      petType: json['petType'] as String?,
      petName: json['petName'] as String?,
      petBirthday: json['petBirthday'] as String?,
      adminAccount: json['adminAccount'] as bool?,
      platform: json['platform'] as String?,
      likePosts: (json['likePosts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      coupons:
          (json['coupons'] as List<dynamic>?)?.map((e) => e as String).toList(),
      point: (json['point'] as num?)?.toInt(),
      eventSigns: (json['eventSigns'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'profile': instance.profile,
      'discription': instance.discription,
      'petType': instance.petType,
      'petName': instance.petName,
      'petBirthday': instance.petBirthday,
      'adminAccount': instance.adminAccount,
      'platform': instance.platform,
      'likePosts': instance.likePosts,
      'coupons': instance.coupons,
      'point': instance.point,
      'eventSigns': instance.eventSigns,
    };
