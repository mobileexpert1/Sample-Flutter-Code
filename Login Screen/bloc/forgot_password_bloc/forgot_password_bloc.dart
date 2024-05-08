import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:player_league/business_logic/models/response_wrapper.dart';
import 'package:player_league/utils/services/all_getter.dart';
import 'package:player_league/utils/services/helpers.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ForgotPasswordRequest>(_onForgotPasswordRequest);
  }

  FutureOr<void> _onForgotPasswordRequest(ForgotPasswordRequest event, Emitter<ForgotPasswordState> emit) async{
    try{
      emit(ForgotPasswordLoading());
      final res = await getAuthRepo.forgotPasswordRequest(body: event.body);
      if(res.status==RepoResponseStatus.success){
        emit(ForgotPasswordLoaded());
      }else{
        emit(ForgotPasswordFailed(error: res.message??someWentWrong));
      }

    }catch(e,s){
      blocLog(msg: e.toString(), bloc: "ForgotPasswordBloc");
      blocLog(msg: s.toString(), bloc: "ForgotPasswordBloc");
      emit(ForgotPasswordFailed(error: e.toString()));
    }
  }
}
