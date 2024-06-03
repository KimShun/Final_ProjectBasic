import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part "user_model.g.dart";

@JsonSerializable()
class UserModel extends Equatable {
  final String? uid;
  final String? name;
  final String? email;
  final String? profile;
  final String? discription;
  final String? petType;
  final String? petName;
  final String? petBirthday;
  final bool? adminAccount;
  final String? platform;
  final List<String>? likePosts;
  final List<String>? coupons;
  final int? point;
  final List<String>? eventSigns;

  const UserModel({
    this.uid,
    this.name,
    this.email,
    this.profile,
    this.discription,
    this.petType,
    this.petName,
    this.petBirthday,
    this.adminAccount,
    this.platform,
    this.likePosts,
    this.coupons,
    this.point,
    this.eventSigns,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toMap() => _$UserModelToJson(this);

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? profile,
    String? discription,
    String? petType,
    String? petName,
    String? petBirthday,
    bool? adminAccount,
    String? platform,
    List<String>? likePosts,
    List<String>? coupons,
    int? point,
    List<String>? eventSigns,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profile: profile ?? this.profile,
      discription: discription ?? this.discription,
      petType: petType ?? this.petType,
      petName: petName ?? this.petName,
      petBirthday: petBirthday ?? this.petBirthday,
      adminAccount: adminAccount ?? this.adminAccount,
      platform: platform ?? this.platform,
      likePosts: likePosts ?? this.likePosts,
      coupons: coupons ?? this.coupons,
      point: point ?? this.point,
      eventSigns: eventSigns ?? this.eventSigns,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [uid, name, email, profile, discription, petType,
    petName, petBirthday, adminAccount, platform, likePosts, coupons, point, eventSigns];
}