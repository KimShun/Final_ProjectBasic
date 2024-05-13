import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_minna_pet/src/common/authentication_process.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/img/aniMall_bg.jpeg",
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.55),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _loginPageTop(),
                    _loginPageCenter(),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _loginPageTop extends StatelessWidget {
  const _loginPageTop({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text("aniMall",
          style: TextStyle(
            fontSize: 33.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: "Jua"
          ),
        ),
        Text("로그인하여 더 다양한 기능을 만나 보세요! \n소중한 친구들이 당신을 기다리고 있습니다!",
          style: TextStyle(
            fontSize: 13.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: "Jua"
          ),
        ),
      ],
    );
  }
}


class _loginPageCenter extends StatefulWidget {
  const _loginPageCenter({super.key});

  @override
  State<_loginPageCenter> createState() => _loginPageCenterState();
}

class _loginPageCenterState extends State<_loginPageCenter> {
  late AuthenticationProcess _authenticationProcess;
  late AuthenticationState _authenticationState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authenticationProcess = AuthenticationProcess();
    _authenticationProcess.init();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("로그인 / 회원가입",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13.0,
            fontFamily: "Jua"
          ),
        ),
        const SizedBox(height: 10.0),
        PlatformLoginBtn(
          "assets/img/kakao_logo.png",
          "Kakao로 계속하기",
          Colors.black,
          Colors.yellowAccent,
            () {},
        ),
        const SizedBox(height: 15.0),
        PlatformLoginBtn(
          "assets/img/google_logo.png",
          "Google로 계속하기",
          Colors.black,
          Colors.white,
          _googleLogin,
        ),
        const SizedBox(height: 15.0),
        PlatformLoginBtn(
          "assets/img/apple_logo.png",
          "Apple로 계속하기",
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
        width: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: bgColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(imgPath,
                width: 33,
                height: 33,
              ),
              const SizedBox(width: 30.0),
              Text(title,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  void _googleLogin() async {
    await _authenticationProcess.googleLogin();
    _authenticationState = _authenticationProcess.getAuthenticationState();

    if(_authenticationState.status == AuthenticationStatus.unAuthenticated) {
      context.push("/signup");
    }
    else if(_authenticationState.status == AuthenticationStatus.authentication) {
      context.go("/");
    }

    print(_authenticationState.status);
  }
}