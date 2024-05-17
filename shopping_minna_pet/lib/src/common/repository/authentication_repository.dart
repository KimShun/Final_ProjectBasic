import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as Kakao;

import '../model/user_model.dart';

class AuthenticationRepository {
  FirebaseAuth _firebaseAuth;
  String? platform;
  AuthenticationRepository(this._firebaseAuth, this.platform);

  Stream<UserModel?> get user{
    return _firebaseAuth.authStateChanges().map<UserModel?>((user) {
      return user == null
          ? null : UserModel(
            name: user.displayName,
            uid: user.uid,
            email: user.email,
            adminAccount: false,
            platform: platform!
          );
    });
  }

  // Firebase - Logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    print("logout!");
  }

  // Google Authentication - login
  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await _firebaseAuth.signInWithCredential(credential);
    platform = "Google";
    print("run!");
  }

  Future<void> signInWithKakao() async {
    // 카카오톡 설치 여부 확인
    // 카카오톡이 설치되어 있으면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    Kakao.OAuthToken? token;
    if (await Kakao.isKakaoTalkInstalled()) {
      try {
        token = await Kakao.UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await Kakao.UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        token = await Kakao.UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }

    var provider = OAuthProvider('oidc.animall'); // 제공업체 id
    var credential = provider.credential(
      idToken: token!.idToken,
      // 카카오 로그인에서 발급된 idToken(카카오 설정에서 OpenID Connect가 활성화 되어있어야함)
      accessToken: token!.accessToken, // 카카오 로그인에서 발급된 accessToken
    );

    await _firebaseAuth.signInWithCredential(credential);
    platform = "Kakao";
  }
}