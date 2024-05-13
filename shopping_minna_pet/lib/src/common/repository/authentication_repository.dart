import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/user_model.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<UserModel?> get user{
    return _firebaseAuth.authStateChanges().map<UserModel?>((user) {
      return user == null
          ? null : UserModel(name: user.displayName, uid: user.uid, email: user.email);
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
  }
}