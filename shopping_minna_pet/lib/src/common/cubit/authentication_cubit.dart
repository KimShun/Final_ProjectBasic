import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shopping_minna_pet/src/common/repository/authentication_repository.dart';
import 'package:shopping_minna_pet/src/common/repository/user_repository.dart';

import '../model/user_model.dart';

class AuthenticationCubit extends HydratedCubit<AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  AuthenticationCubit(this._authenticationRepository, this._userRepository) : super(AuthenticationState());

  void init() {
    // _authenticationRepository.logout();
    // logout();
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
      if(user.uid != null && user.email != null) {
        var result = await _userRepository.findUserOne(user.uid!);
        var checkRegisterEmail = await _userRepository.findUserOneFromEmail(
            user.email!);
        if (checkRegisterEmail == null && result == null) {
          emit(state.copyWith(
              user: user, status: AuthenticationStatus.unAuthenticated));
        } else {
          if (checkRegisterEmail?.platform != user.platform) {
            emit(state.copyWith(
                user: checkRegisterEmail, status: AuthenticationStatus.error));
          } else {
            emit(state.copyWith(
                user: result, status: AuthenticationStatus.authentication));
          }
        }
      }
    }
  }

  void reloadAuth() {
    _userStateChangedEvent(state.user);
  }

  void googleLogin() async {
    await _authenticationRepository.signInWithGoogle();
    await Future.delayed(const Duration(milliseconds: 1000));
    init();
  }

  void kakaoLogin() async {
    await _authenticationRepository.signInWithKakao();
    await Future.delayed(const Duration(milliseconds: 1000));
    init();
  }

  void logout() async {
    await _authenticationRepository.logout();
    await HydratedBloc.storage.clear();
    emit(state.copyWith(status: AuthenticationStatus.unknown));
  }

  Future<String?> findUserName(String uid) async {
    var result = await _userRepository.findUserOne(uid);
    return result!.name;
  }

  // @override
  // void onChange(Change<AuthenticationState> change) {
  //   // TODO: implement onChange
  //   super.onChange(change);
  //   print(change);
  // }

  @override
  AuthenticationState? fromJson(Map<String, dynamic> json) {
    try {
      return AuthenticationState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthenticationState state) {
    try {
      return state.toJson();
    } catch(_) {
      return null;
    }
  }
}

@JsonEnum(fieldRename: FieldRename.snake)
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

  factory AuthenticationState.fromJson(Map<String, dynamic> json) {
    return AuthenticationState(
      status: json['status'] as AuthenticationStatus,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.toString(),
      'user': user?.toMap(),
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status, user];
}