import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_minna_pet/src/auth/signup.dart';
import 'package:shopping_minna_pet/src/common/cubit/authentication_cubit.dart';
import 'package:shopping_minna_pet/src/home.dart';

import '../common/model/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<AuthenticationCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double phoneWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.error) {
            return _alreadyEmailError(state.user!);
          }
          else if (state.status == AuthenticationStatus.unAuthenticated) {
            return const SignUpScreen();
          }
          else if(state.status == AuthenticationStatus.authentication) {
            return const HomeScreen();
          }
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset("assets/img/aniMall_bg.jpeg",
                fit: BoxFit.cover,
              ),
              Container(
                color: Colors.black.withOpacity(0.55),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _loginPageTop(phoneWidth: phoneWidth),
                        _loginPageCenter(phoneWidth: phoneWidth),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _alreadyEmailError(UserModel user) {
    return AlertDialog(
      title: const Text("알림"),
      content: Text("이미 가입되어 있는 이메일입니다. \n다른 플랫폼으로 로그인 해주세요. \n${user.email}"),
      actions: [
        TextButton(
          onPressed: () {
            context.read<AuthenticationCubit>().logout();
          },
          child: const Text("확인"),
        ),
      ],
    );
  }
}

class _loginPageTop extends StatelessWidget {
  final double phoneWidth;

  const _loginPageTop({
    required this.phoneWidth,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("aniMall",
          style: TextStyle(
            fontSize: phoneWidth >= 400 ? 40.0 : 35.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: "Jua"
          ),
        ),
        Text("로그인하여 더 다양한 기능을 만나 보세요! \n소중한 친구들이 당신을 기다리고 있습니다!",
          style: TextStyle(
            fontSize: phoneWidth >= 400 ? 15.0 : 13.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: "Jua"
          ),
        ),
      ],
    );
  }
}


class _loginPageCenter extends StatelessWidget {
  final double phoneWidth;

  const _loginPageCenter({
    required this.phoneWidth,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("[ 로그인 / 회원가입 ]",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: phoneWidth >= 400 ? 15.0 : 13.0,
            fontFamily: "Jua",
          ),
        ),
        const SizedBox(height: 10.0),
        PlatformLoginBtn(
          "assets/img/kakao_logo.png",
          "카카오 로그인",
          Colors.black,
          const Color(0xFFFDDC3F),
          () {
            context.read<AuthenticationCubit>().kakaoLogin();
          },
        ),
        const SizedBox(height: 15.0),
        PlatformLoginBtn(
          "assets/img/google_logo.png",
          "구글 로그인",
          Colors.black,
          Colors.white,
          () {
            context.read<AuthenticationCubit>().googleLogin();
          }
        ),
        const SizedBox(height: 15.0),
        PlatformLoginBtn(
          "assets/img/apple_logo.png",
          "애플 로그인",
          Colors.white,
          Colors.black87,
          () {}
        )
      ],
    );
  }

  Widget PlatformLoginBtn(String imgPath, String title, Color titleColor, Color bgColor, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: bgColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(imgPath,
                width: phoneWidth >= 400 ? 35 : 33,
                height: phoneWidth >= 400 ? 35 : 33,
              ),
              Expanded(
                child: Center(
                  child: Text(title,
                    style: TextStyle(
                      fontSize: phoneWidth >= 400 ? 17.0 : 15.0,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}