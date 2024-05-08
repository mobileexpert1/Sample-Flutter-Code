part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpState extends Equatable {
  const SignUpState();
}

class SignUpInitial extends SignUpState {
  @override
  List<Object?> get props => [];

}
class SignUpLoading extends SignUpState {
  @override
  List<Object?> get props => [];

}
class SignUpLoaded extends SignUpState {
  @override
  List<Object?> get props => [];

}
class SignUpSuccess extends SignUpState {
  final String email;

  SignUpSuccess({required this.email});
  @override
  List<Object?> get props => [email];

}
class SignUpFailed extends SignUpState {
  final String error;
  const SignUpFailed({required this.error});
  @override
  List<Object?> get props => [error];

}
