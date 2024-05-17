import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_minna_pet/src/auth/cubit/signup_cubit.dart';
import 'package:shopping_minna_pet/src/common/component/app_text.dart';
import 'package:shopping_minna_pet/src/common/cubit/authentication_cubit.dart';

import '../common/cubit/upload_cubit.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double phoneWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      body: MultiBlocListener(
        listeners: [
          BlocListener<SignUpCubit, SignUpState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              switch (state.status) {
                case SignUpStatus.init:
                  break;
                case SignUpStatus.loading:
                  break;
                case SignUpStatus.uploading:
                  context.read<UploadCubit>().uploadUserProfile(state.profileFile!, state.userModel!.uid!);
                  break;
                case SignUpStatus.success:
                  context.read<AuthenticationCubit>().reloadAuth();
                  break;
                case SignUpStatus.error:
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
                  context.read<SignUpCubit>().uploadPercent(state.percent!.toStringAsFixed(2));
                  break;
                case UploadStatus.success:
                  context.read<SignUpCubit>().updateProfileImageUrl(state.url!);
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
            Image.asset("assets/img/aniMall_bg.jpeg",
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black.withOpacity(0.55),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // 프로필 이미지 설정
                        _UserProfileImageField(),
                        const SizedBox(height: 20.0),
                        // 주인 & 반려동물 정보입력
                        _UserProfileDetailField(phoneWidth: phoneWidth),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            BlocBuilder<SignUpCubit, SignUpState>(
              buildWhen: (previous, current) => previous.percent != current.percent || previous.status != current.status,
              builder: (context, state) {
                if(state.percent != null && state.status == SignUpStatus.uploading) {
                  return Container(
                    color: Colors.black.withOpacity(0.8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          title: "[ 회원가입 중... ]",
                          fontSize: phoneWidth >= 400 ? 18.0 : 16.0,
                          color: Colors.yellow,
                        ),
                        const SizedBox(height: 10.0),
                        SizedBox(
                          width: phoneWidth >= 400 ? 35.0 : 30.0,
                          height: phoneWidth >= 400 ? 35.0 : 30.0,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: Colors.yellowAccent,
                          ),
                        ),
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
    var profileImage = context.select<SignUpCubit, File?>((value) => value.state.profileFile);
    return GestureDetector(
      onTap: () async {
        var image = await _picker.pickImage(source: ImageSource.gallery);
        context.read<SignUpCubit>().changeProfileImage(image);
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 50.0,
            backgroundImage: profileImage == null
                ? Image.asset("assets/icon/default_avatar.png").image
                : Image.file(profileImage).image,
          ),
          const SizedBox(height: 10.0),
          AppText(
            title: "[ 프로필 이미지를 설정해주세요. ]",
            fontSize: MediaQuery.of(context).size.width >= 400 ? 14.0 : 12.0,
            color: Colors.yellow,
          ),
          AppText(
            title: "${context.select<AuthenticationCubit, String?>((value) => value.state.user!.platform)}: "
                + "${context.select<AuthenticationCubit, String?>((value) => value.state.user!.email)}",
            fontSize: MediaQuery.of(context).size.width >= 400 ? 14.0 : 12.0,
            color: Colors.white,
          ),
        ],
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
      height: MediaQuery.of(context).size.height * 0.6,
      child: ListView(
        children: [
          _ownerInfoField(context),
          const SizedBox(height: 10.0),
          _animalInfoField(context),
        ],
      ),
    );
  }

  Widget _ownerInfoField(BuildContext context) {
    return Column(
      children: [
        AppText(
          title: "----- [ 주인 정보입력 ] -----",
          fontSize: phoneWidth >= 400.0 ? 20.0 : 18.0,
          color: Colors.yellow,
          textAlign: TextAlign.center,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              title: "닉네임(이름)",
              fontSize: phoneWidth >= 400.0 ? 17.0 : 15.0,
            ),
            TextField(
              onChanged: (value) {
                context.read<SignUpCubit>().changeName(value);
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
                color: Colors.white,
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
            ),
            TextField(
              onChanged: (value) {
                context.read<SignUpCubit>().changeDiscription(value);
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
                color: Colors.white,
                fontSize: phoneWidth >= 400.0 ? 17.0 : 15.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _animalInfoField(BuildContext context) {
    return Column(
      children: [
        AppText(
          title: "----- [ 반려동물 정보입력 ] -----",
          fontSize: phoneWidth >= 400.0 ? 20.0 : 18.0,
          color: Colors.yellow,
          textAlign: TextAlign.center,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              title: "반려동물 - 이름",
              fontSize: phoneWidth >= 400.0 ? 17.0 : 15.0,
            ),
            TextField(
              onChanged: (value) {
                context.read<SignUpCubit>().changePetName(value);
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
                color: Colors.white,
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
            ),
            TextField(
              onChanged: (value) {
                context.read<SignUpCubit>().changePetType(value);
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
                color: Colors.white,
                fontSize: phoneWidth >= 400.0 ? 17.0 : 15.0,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  title: "반려동물 - 생일",
                  fontSize: phoneWidth >= 400.0 ? 17.0 : 15.0,
                ),
                TextField(
                  onChanged: (value) {
                    context.read<SignUpCubit>().changePetBirthday(value);
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
                    color: Colors.white,
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
          onPressed: () {
            context.read<AuthenticationCubit>().logout();
          },
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
            context.read<SignUpCubit>().save();
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
              title: "가입완료!!",
              fontSize: phoneWidth >= 400 ? 20.0 : 18.0,
            ),
          )
        ),
      ],
    );
  }
}
