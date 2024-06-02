import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_minna_pet/src/common/component/app_loading_circular.dart';
import 'package:shopping_minna_pet/src/common/component/app_text.dart';
import 'package:shopping_minna_pet/src/common/cubit/authentication_cubit.dart';
import 'package:shopping_minna_pet/src/profile/cubit/modify_profile_cubit.dart';

import '../common/cubit/upload_cubit.dart';

class ModifyProfileScreen extends StatelessWidget {
  const ModifyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double phoneWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      body: MultiBlocListener(
        listeners: [
          BlocListener<ModifyProfileCubit, ModifyProfileState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              switch (state.status) {
                case ModifyStatus.init:
                  break;
                case ModifyStatus.loading:
                  break;
                case ModifyStatus.uploading:
                  context.read<UploadCubit>().uploadImage(state.m_profileImage!, state.userModel!.uid!, "users", "profile");
                  break;
                case ModifyStatus.success:
                  context.read<AuthenticationCubit>().reloadAuth();
                  context.go("/profile");
                  break;
                case ModifyStatus.error:
                  break;
              }
            }
          ),
          BlocListener<UploadCubit, UploadState>(
            listener: (context, state) {
              switch (state.status) {
                case UploadStatus.init:
                  break;
                case UploadStatus.uploading:
                  context.read<ModifyProfileCubit>().uploadPercent(state.percent!.toStringAsFixed(2));
                  break;
                case UploadStatus.success:
                  context.read<ModifyProfileCubit>().updateProfileImageUrl(state.url!);
                  break;
                case UploadStatus.error:
                  break;
              }
            },
          )
        ],
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              child: SafeArea(
                child: ListView(
                  children: [
                    Column(
                      children: [
                        // 프로필 이미지 설정
                        _UserProfileImageField(),
                        const SizedBox(height: 20.0),
                        // 주인 & 반려동물 정보입력
                        _UserProfileDetailField(phoneWidth: phoneWidth),
                      ],
                    ),
                  ]
                ),
              ),
            ),
            BlocBuilder<ModifyProfileCubit, ModifyProfileState>(
              buildWhen: (previous, current) => previous.percent != current.percent || previous.status != current.status,
              builder: (context, state) {
                if(state.percent != null && state.status == ModifyStatus.uploading) {
                  return Container(
                    color: Colors.black.withOpacity(0.8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          title: "[ 수정중... ]",
                          fontSize: phoneWidth >= 400 ? 18.0 : 16.0,
                          color: Colors.yellow,
                        ),
                        const SizedBox(height: 10.0),
                        const AppLoadingCircular(),
                        const SizedBox(height: 10.0),
                        AppText(
                          title: "${state.percent}%",
                          fontSize: phoneWidth >= 400 ? 16.0 : 14.0,
                        )
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: phoneWidth >= 400 ? 50.0 : 40.0),
        child: _SignUpButton(
          phoneWidth: phoneWidth,
        ),
      ),
    );
  }
}

class _UserProfileImageField extends StatelessWidget {
  _UserProfileImageField({super.key});
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var image = await _picker.pickImage(source: ImageSource.gallery);
        context.read<ModifyProfileCubit>().changeProfileImage(image);
      },
      child: BlocBuilder<ModifyProfileCubit, ModifyProfileState>(
        builder: (context, state) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   CircleAvatar(
                     backgroundColor: Colors.grey,
                     radius: 50.0,
                     backgroundImage: state.isChangeImage! ? Image.file(state.m_profileImage!).image : Image.network(state.profileImage!).image
                  ),
                  _imageProfileCancelBtn(changeImage: state.isChangeImage)
                ],
              ),
              const SizedBox(height: 10.0),
              AppText(
                title: "[ 변경을 원하시면 클릭해주세요. ]",
                fontSize: MediaQuery.of(context).size.width >= 400 ? 14.0 : 12.0,
                color: Colors.orange,
              ),
              AppText(
                title: "${context.select<AuthenticationCubit, String?>((value) => value.state.user!.platform)}: "
                    + "${context.select<AuthenticationCubit, String?>((value) => value.state.user!.email)}",
                fontSize: MediaQuery.of(context).size.width >= 400 ? 14.0 : 12.0,
                color: Colors.black,
              ),
            ],
          );
        }
      ),
    );
  }
}

class _UserProfileDetailField extends StatelessWidget {
  final double phoneWidth;

  const _UserProfileDetailField({
    required this.phoneWidth,
    super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: BlocBuilder<ModifyProfileCubit, ModifyProfileState>(
        builder: (context, state) {
          return Column(
            children: [
              _ownerInfoField(context, state),
              const SizedBox(height: 10.0),
              _animalInfoField(context, state),
            ],
          );
        }
      ),
    );
  }

  Widget _ownerInfoField(BuildContext context, ModifyProfileState state) {
    return Column(
      children: [
        AppText(
          title: "----- [ 주인 정보입력 ] -----",
          fontSize: phoneWidth >= 400.0 ? 20.0 : 18.0,
          color: Colors.orange,
          textAlign: TextAlign.center,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              title: "닉네임(이름)",
              fontSize: phoneWidth >= 400.0 ? 17.0 : 15.0,
              color: Colors.black,
            ),
            TextField(
              controller: state.nameController,
              onChanged: (value) {
                context.read<ModifyProfileCubit>().changeUserName(value);
              },
              maxLength: 10,
              maxLines: 1,
              decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orangeAccent)
                  ),
                  hintText: "닉네임을 알려주세요.",
                  prefixIcon: Icon(Icons.account_circle_outlined, color: Colors.orangeAccent,)
              ),
              style: TextStyle(
                fontFamily: "Jua",
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: phoneWidth >= 400.0 ? 17.0 : 15.0,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              title: "한줄소개",
              fontSize: phoneWidth >= 400.0 ? 17.0 : 15.0,
              color: Colors.black,
            ),
            TextField(
              controller: state.discriptionController,
              onChanged: (value) {
                context.read<ModifyProfileCubit>().changeUserDiscription(value);
              },
              maxLength: 20,
              maxLines: 1,
              decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orangeAccent)
                  ),
                  hintText: "자신을 한 줄로 소개해주세요.",
                  prefixIcon: Icon(Icons.abc_rounded, color: Colors.orangeAccent,)
              ),
              style: TextStyle(
                fontFamily: "Jua",
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: phoneWidth >= 400.0 ? 17.0 : 15.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _animalInfoField(BuildContext context, ModifyProfileState state) {
    return Column(
      children: [
        AppText(
          title: "----- [ 반려동물 정보입력 ] -----",
          fontSize: phoneWidth >= 400.0 ? 20.0 : 18.0,
          color: Colors.orange,
          textAlign: TextAlign.center,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              title: "반려동물 - 이름",
              fontSize: phoneWidth >= 400.0 ? 17.0 : 15.0,
              color: Colors.black,
            ),
            TextField(
              controller: state.petNameController,
              onChanged: (value) {
                context.read<ModifyProfileCubit>().changeUserPetName(value);
              },
              maxLength: 20,
              maxLines: 1,
              decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orangeAccent)
                ),
                hintText: "반려동물의 이름을 알려주세요.",
                prefixIcon: Image.asset("assets/icon/nameTagIcon.png",
                  scale: 23.0,
                  color: Colors.orangeAccent,
                ),
              ),
              style: TextStyle(
                fontFamily: "Jua",
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: phoneWidth >= 400.0 ? 17.0 : 15.0,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              title: "반려동물 - 종류",
              fontSize: phoneWidth >= 400.0 ? 17.0 : 15.0,
              color: Colors.black,
            ),
            TextField(
              controller: state.petTypeController,
              onChanged: (value) {
                context.read<ModifyProfileCubit>().changeUserPetType(value);
              },
              maxLength: 20,
              maxLines: 1,
              decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orangeAccent)
                ),
                hintText: "어떤 종인지 알려주세요. ex) 강아지 (말티즈)",
                prefixIcon: Image.asset("assets/icon/dogIcon.png",
                  scale: 23.0,
                  color: Colors.orangeAccent,
                ),
              ),
              style: TextStyle(
                fontFamily: "Jua",
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: phoneWidth >= 400.0 ? 17.0 : 15.0,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  title: "반려동물 - 생일",
                  fontSize: phoneWidth >= 400.0 ? 17.0 : 15.0,
                  color: Colors.black,
                ),
                TextField(
                  controller: state.petBirthdayController,
                  onChanged: (value) {
                    context.read<ModifyProfileCubit>().changeUserPetBirthday(value);
                  },
                  maxLength: 20,
                  maxLines: 1,
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orangeAccent)
                    ),
                    hintText: "생일이 언제인지 알려주세요. ex) xx월 xx일",
                    prefixIcon: Image.asset("assets/icon/birthdayIcon.png",
                      scale: 23.0,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: "Jua",
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: phoneWidth >= 400.0 ? 17.0 : 15.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _SignUpButton extends StatelessWidget {
  final double phoneWidth;

  const _SignUpButton({
    required this.phoneWidth,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: AppText(
                title: "취소..",
                fontSize: phoneWidth >= 400 ? 20.0 : 18.0,
              ),
            )
        ),
        const SizedBox(width: 15.0),
        ElevatedButton(
            onPressed: () {
              context.read<ModifyProfileCubit>().save();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: AppText(
                title: "수정완료!!",
                fontSize: phoneWidth >= 400 ? 20.0 : 18.0,
              ),
            )
        ),
      ],
    );
  }
}

class _imageProfileCancelBtn extends StatelessWidget {
  final bool? changeImage;

  const _imageProfileCancelBtn({
    this.changeImage,
    super.key});

  @override
  Widget build(BuildContext context) {
    if(changeImage == false) {
      return Container();
    } else {
      return IconButton(
        onPressed: () => context.read<ModifyProfileCubit>().cancelChangeProfileImage(),
        icon: const Icon(Icons.refresh,
          size: 20.0,
        ),
      );
    }
  }
}
