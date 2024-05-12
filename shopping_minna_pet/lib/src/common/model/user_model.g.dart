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
      petBirthday: json['petBirthday'] == null
          ? null
          : DateTime.parse(json['petBirthday'] as String),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'profile': instance.profile,
      'discription': instance.discription,
      'petType': instance.petType,
      'petName': instance.petName,
      'petBirthday': instance.petBirthday?.toIso8601String(),
    };
