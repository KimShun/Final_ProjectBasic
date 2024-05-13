import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/model/user_model.dart';
import '../../common/repository/user_repository.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final UserRepository _userRepository;
  SignUpCubit(UserModel userModel, this._userRepository) : super(SignUpState(userModel: userModel));

  void changeProfileImage(XFile? imageFile) {
    if(imageFile == null) { return; }

    var file = File(imageFile.path);
    emit(state.copyWith(profileFile: file));
  }

  void changeName(String name) {
    emit(state.copyWith(name: name));
  }

  void changeDiscription(String discription) {
    emit(state.copyWith(discription: discription));
  }

  void changePetName(String petName) {
    emit(state.copyWith(petName: petName));
  }

  void changePetType(String petType) {
    emit(state.copyWith(petType: petType));
  }

  void changePetBirthday(String petBirthday) {
    emit(state.copyWith(petBirthday: petBirthday));
  }

  void uploadPercent(String percent) {
    emit(state.copyWith(percent: percent));
  }

  void updateProfileImageUrl(String url) {
    emit(state.copyWith(userModel: state.userModel!.copyWith(profile: url), status: SignUpStatus.loading));
    submit();
  }

  void save() {
    if(state.name == null || state.name == "") return;
    emit(state.copyWith(status: SignUpStatus.loading));
    if(state.profileFile != null) {
      emit(state.copyWith(status: SignUpStatus.uploading));
    } else {
      submit();
    }
  }

  void submit() async {
    var joinUserModel = state.userModel!.copyWith(name: state.name, discription: state.discription, petName: state.petName, petType: state.petType, petBirthday: state.petBirthday);
    var result = await _userRepository.joinUser(joinUserModel);

    if(result) {
      emit(state.copyWith(status: SignUpStatus.success));
    } else {
      emit(state.copyWith(status: SignUpStatus.error));
    }
  }
}

enum SignUpStatus {
  init,
  loading,
  uploading,
  success,
  error
}

class SignUpState extends Equatable {
  final File? profileFile;
  final String? name;
  final String? discription;
  final String? petName;
  final String? petType;
  final String? petBirthday;
  final String? percent;
  final SignUpStatus status;
  final UserModel? userModel;

  const SignUpState({
    this.profileFile,
    this.name,
    this.discription,
    this.petName,
    this.petType,
    this.petBirthday,
    this.percent,
    this.status = SignUpStatus.init,
    this.userModel
  });

  SignUpState copyWith({
    File? profileFile,
    String? name,
    String? discription,
    String? petName,
    String? petType,
    String? petBirthday,
    String? percent,
    SignUpStatus? status,
    UserModel? userModel
  }) {
    return SignUpState(
      profileFile: profileFile ?? this.profileFile,
      name: name ?? this.name,
      discription: discription ?? this.discription,
      petName: petName ?? this.petName,
      petType: petType ?? this.petType,
      petBirthday: petBirthday ?? this.petBirthday,
      percent: percent ?? this.percent,
      status: status ?? this.status,
      userModel: userModel ?? this.userModel,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [profileFile, name, discription, petName, petType, petBirthday, percent, status, userModel];
}