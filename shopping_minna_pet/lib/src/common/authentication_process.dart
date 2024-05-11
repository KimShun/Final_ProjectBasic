import 'package:equatable/equatable.dart';
import 'package:shopping_minna_pet/src/common/repository/authentication_repository.dart';
import 'package:shopping_minna_pet/src/common/repository/user_repository.dart';

import 'model/user_model.dart';

class AuthenticationProcess {
  final AuthenticationRepository _authenticationRepository = AuthenticationRepository();
  final UserRepository _userRepository = UserRepository();
  AuthenticationState authenticationState = const AuthenticationState();

  void init() {
    // _authenticationRepository.logout();
    _authenticationRepository.user.listen((user) {
      _userStateChangedEvent(user);
    });
    getAuthenticationState();
  }

  void _userStateChangedEvent(UserModel? user) async {
    if(user == null) {
      // TODO 로그아웃 상태
      authenticationState = authenticationState.copyWith(status: AuthenticationStatus.unknown);

    } else {
      // TODO 로그인 상태
      var result = await _userRepository.findUserOne(user.uid!);
      if(result == null) {
        authenticationState = authenticationState.copyWith(user: user, status: AuthenticationStatus.unAuthenticated);
      } else {
        authenticationState = authenticationState.copyWith(user: user, status: AuthenticationStatus.authentication);
      }
    }
  }

  void reloadAuth() {
    _userStateChangedEvent(authenticationState.user);
  }

  Future<void> googleLogin() async {
    await _authenticationRepository.signInWithGoogle();
  }

  AuthenticationState getAuthenticationState() {
    return authenticationState;
  }
}

enum AuthenticationStatus {
  authentication,
  unAuthenticated,
  unknown,
  init,
  error,
}

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final UserModel? user;

  const AuthenticationState({
    this.status = AuthenticationStatus.init,
    this.user,
  });

  AuthenticationState copyWith({
    AuthenticationStatus? status,
    UserModel? user,
  }) {
    return AuthenticationState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status, user];
}