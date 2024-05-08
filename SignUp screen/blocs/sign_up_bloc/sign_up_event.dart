part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
}

class GetSignUp extends SignUpEvent {
  final Map<String, dynamic> body;

  const GetSignUp({required this.body});

  @override
  List<Object?> get props => [body];
}
