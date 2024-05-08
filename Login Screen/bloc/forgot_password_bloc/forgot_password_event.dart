part of 'forgot_password_bloc.dart';
abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
}
class ForgotPasswordRequest extends ForgotPasswordEvent{
  final Map<String,dynamic>body;
   const ForgotPasswordRequest({required this.body});
  @override
  List<Object?> get props => [body];
}