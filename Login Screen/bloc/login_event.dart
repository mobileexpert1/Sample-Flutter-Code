part of 'login_bloc.dart';

  @immutable
  abstract class LoginEvent extends Equatable {
    const LoginEvent();
  }

class GetLogin extends LoginEvent {
  final Map<String, dynamic> body;

  const GetLogin({
    required this.body,
  });

  @override
  List<Object?> get props => [body];
}
class GetSocialLogin extends LoginEvent {
  final Map<String, dynamic> body;

  const GetSocialLogin({
    required this.body,
  });

  @override
  List<Object?> get props => [body];
}
