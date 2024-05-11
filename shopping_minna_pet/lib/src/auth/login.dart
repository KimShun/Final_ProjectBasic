import 'package:flutter/material.dart';
import 'package:shopping_minna_pet/src/common/authentication_process.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              await _authenticationProcess.googleLogin();
              setState(() {
                _authenticationState = _authenticationProcess.getAuthenticationState();
              });
              print(_authenticationState.status);
              print(_authenticationState.user!.uid);
            },
            child: const Text("구글 로그인")
        ),
      ),
    );
  }
}