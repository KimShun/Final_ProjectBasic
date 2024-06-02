import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/model/user_model.dart';
import '../../common/repository/user_repository.dart';

class ModifyProfileCubit extends Cubit<ModifyProfileState> {
  final UserModel userModel;
  final UserRepository _userRepository;

  ModifyProfileCubit(this.userModel, this._userRepository) : super(ModifyProfileState(
    userModel: userModel,
    profileImage: userModel.profile,
    isChangeImage: false,
    nameController: TextEditingController(text: userModel.name),
    discriptionController: TextEditingController(text: userModel.discription),
    petNameController: TextEditingController(text: userModel.petName),
    petTypeController: TextEditingController(text: userModel.petType),
    petBirthdayController: TextEditingController(text: userModel.petBirthday),
  ));

  void changeUserName(String value) {
    state.nameController!.text = value;
    state.nameController!.selection = TextSelection.fromPosition(TextPosition(offset: state.nameController!.text.length));
    emit(state.copyWith(nameController: state.nameController));
  }

  void changeUserDiscription(String value) {
    state.discriptionController!.text = value;
    state.discriptionController!.selection = TextSelection.fromPosition(TextPosition(offset: state.discriptionController!.text.length));
    emit(state.copyWith(discriptionController: state.discriptionController));
  }

  void changeUserPetName(String value) {
    state.petNameController!.text = value;
    state.petNameController!.selection = TextSelection.fromPosition(TextPosition(offset: state.petNameController!.text.length));
    emit(state.copyWith(petNameController: state.petNameController));
  }

  void changeUserPetType(String value) {
    state.petTypeController!.text = value;
    state.petTypeController!.selection = TextSelection.fromPosition(TextPosition(offset: state.petTypeController!.text.length));
    emit(state.copyWith(petTypeController: state.petTypeController));
  }

  void changeUserPetBirthday(String value) {
    state.petBirthdayController!.text = value;
    state.petBirthdayController!.selection = TextSelection.fromPosition(TextPosition(offset: state.petBirthdayController!.text.length));
    emit(state.copyWith(petBirthdayController: state.petBirthdayController));
  }

  void changeProfileImage(XFile? imageFile) {
    if(imageFile == null) { return; }

    var file = File(imageFile.path);
    emit(state.copyWith(m_profileImage: file, isChangeImage: true));
  }

  void cancelChangeProfileImage() {
    emit(state.copyWith(isChangeImage: false));
  }

  void uploadPercent(String percent) {
    emit(state.copyWith(percent: percent));
  }

  void updateProfileImageUrl(String url) {
    emit(state.copyWith(userModel: state.userModel!.copyWith(profile: url), status: ModifyStatus.loading));
    submit();
  }

  void save() {
    if(state.nameController!.text == "") return;
    emit(state.copyWith(status: ModifyStatus.loading));

    if(state.isChangeImage!) {
      print("chjec!");
      emit(state.copyWith(status: ModifyStatus.uploading));
    } else {
      submit();
    }
  }

  void submit() async {
    var joinUserModel = state.userModel!.copyWith(
      name: state.nameController!.text,
      discription: state.discriptionController!.text,
      petName: state.petNameController!.text,
      petType: state.petTypeController!.text,
      petBirthday: state.petBirthdayController!.text
    );

    var result = await _userRepository.joinUser(joinUserModel);
    if(result) {
      emit(state.copyWith(status: ModifyStatus.success));
    } else {
      emit(state.copyWith(status: ModifyStatus.error));
    }
  }

}

enum ModifyStatus {
  init,
  loading,
  uploading,
  success,
  error
}

class ModifyProfileState extends Equatable {
  final UserModel? userModel;
  final String? profileImage;
  final File? m_profileImage;
  final ModifyStatus status;
  final TextEditingController? nameController;
  final TextEditingController? discriptionController;
  final TextEditingController? petNameController;
  final TextEditingController? petTypeController;
  final TextEditingController? petBirthdayController;
  final String? percent;
  final bool? isChangeImage;

  const ModifyProfileState({
    this.userModel,
    this.profileImage,
    this.m_profileImage,
    this.status = ModifyStatus.init,
    this.nameController,
    this.discriptionController,
    this.petNameController,
    this.petTypeController,
    this.petBirthdayController,
    this.percent,
    this.isChangeImage,
  });

  ModifyProfileState copyWith({
    UserModel? userModel,
    String? profileImage,
    File? m_profileImage,
    ModifyStatus? status,
    TextEditingController? nameController,
    TextEditingController? discriptionController,
    TextEditingController? petNameController,
    TextEditingController? petTypeController,
    TextEditingController? petBirthdayController,
    String? percent,
    bool? isChangeImage,
  }) {
    return ModifyProfileState(
      userModel: userModel ?? this.userModel,
      profileImage: profileImage ?? this.profileImage,
      m_profileImage: m_profileImage ?? this.m_profileImage,
      status: status ?? this.status,
      nameController: nameController ?? this.nameController,
      discriptionController: discriptionController ?? this.discriptionController,
      petNameController: petNameController ?? this.petNameController,
      petTypeController: petTypeController ?? this.petTypeController,
      petBirthdayController: petBirthdayController ?? this.petBirthdayController,
      percent: percent ?? this.percent,
      isChangeImage: isChangeImage ?? this.isChangeImage,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [userModel, profileImage, m_profileImage, status, nameController, discriptionController, petNameController, petTypeController, petBirthdayController, percent, isChangeImage];
}