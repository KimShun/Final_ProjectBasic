import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_minna_pet/src/common/component/app_text.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final double phoneWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      body: Stack(
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
                      const _UserProfileImageField(),
                      const SizedBox(height: 20.0),
                      // 주인 & 반려동물 정보입력
                      _UserProfileDetailField(phoneWidth: phoneWidth),
                      const SizedBox(height: 20.0),
                      // 버튼 3개 ( 취소, 완료, 새로고침 )
                      _SignUpButton(phoneWidth: phoneWidth)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserProfileImageField extends StatefulWidget {
  const _UserProfileImageField({super.key});

  @override
  State<_UserProfileImageField> createState() => _UserProfileImageFieldState();
}

class _UserProfileImageFieldState extends State<_UserProfileImageField> {
  final ImagePicker _picker = ImagePicker();
  File? imagePath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var image = await _picker.pickImage(source: ImageSource.gallery);
        setState(() {
          imagePath = File(image!.path);
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 50.0,
            backgroundImage: imagePath == null
                ? Image.asset("assets/icon/default_avatar.png").image
                : Image.file(imagePath!).image,
          ),
          const SizedBox(height: 10.0),
          AppText(
            title: "[ 프로필 이미지를 설정해주세요. ]",
            fontSize: MediaQuery.of(context).size.width >= 400 ? 14.0 : 12.0,
            color: Colors.yellow,
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
          _ownerInfoField(),
          const SizedBox(height: 10.0),
          _animalInfoField(),
        ],
      ),
    );
  }

  Widget _ownerInfoField() {
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

  Widget _animalInfoField() {
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
            // SizedBox(height: MediaQuery.of(context).viewInsets.bottom * 0.7),
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
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: AppText(
              title: "취소..",
              fontSize: phoneWidth >= 400 ? 20.0 : 18.0,
            )
        ),
        const SizedBox(width: 10.0),
        ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: AppText(
              title: "가입완료!!",
              fontSize: phoneWidth >= 400 ? 20.0 : 18.0,
            )
        ),
        const SizedBox(width: 10.0),
        ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Icon(Icons.refresh_outlined,
              color: Colors.black54,
            )
        ),
      ],
    );
  }
}
