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

  const UserModel({
    this.uid,
    this.name,
    this.email,
    this.profile,
    this.discription,
    this.petType,
    this.petName,
    this.petBirthday,
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
    String? petBirthday
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
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [uid, name, email, profile, discription, petType, petName, petBirthday];
}