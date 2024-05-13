import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:shopping_minna_pet/src/common/repository/authentication_repository.dart';
import 'package:shopping_minna_pet/src/common/repository/user_repository.dart';

import '../model/user_model.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> with ChangeNotifier {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  AuthenticationCubit(this._authenticationRepository, this._userRepository) : super(AuthenticationState());

  void init() {
    // _authenticationRepository.logout();
    _authenticationRepository.user.listen((user) {
      _userStateChangedEvent(user);
    });
  }

  void _userStateChangedEvent(UserModel? user) async {
    if(user == null) {
      // TODO 로그아웃 상태
      emit(state.copyWith(status: AuthenticationStatus.unknown));
    } else {
      // TODO 로그인 상태
      var result = await _userRepository.findUserOne(user.uid!);
      if(result == null) {
        emit(state.copyWith(user: user, status: AuthenticationStatus.unAuthenticated));
      } else {
        emit(state.copyWith(user: result, status: AuthenticationStatus.authentication));
      }
    }
  }

  void reloadAuth() {
    _userStateChangedEvent(state.user);
  }

  void googleLogin() async {
    await _authenticationRepository.signInWithGoogle();
    init();
  }

  void kakaoLogin() async {
    await _authenticationRepository.signInWithKakao();
    init();
  }

  void logout() async {
    await _authenticationRepository.logout();
  }

  @override
  void onChange(Change<AuthenticationState> change) {
    // TODO: implement onChange
    super.onChange(change);
    print(change);
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