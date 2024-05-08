part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {}

class LoginInitial extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object?> get props => [];
}
class LoginSocialLoading extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginLoaded extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginSuccess extends LoginState {
  final LoginModel loginModel;

  LoginSuccess({required this.loginModel});
  @override
  List<Object?> get props => [loginModel];
}

class LoginFailed extends LoginState {
  final String error;

  LoginFailed({required this.error});

  @override
  List<Object?> get props => [];
}
