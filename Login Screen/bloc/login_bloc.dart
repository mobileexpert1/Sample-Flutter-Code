import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:player_league/screens/login_screen/model/LoginModel.dart';

import '../../../business_logic/models/response_wrapper.dart';
import '../../../utils/services/all_getter.dart';
import '../../../utils/services/helpers.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<GetLogin>(_onLogin);
    on<GetSocialLogin>(_onGetSocialLogin);
  }

  Future<FutureOr<void>> _onLogin(
    GetLogin event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(LoginLoading());
      ResponseWrapper res = await getAuthRepo.userLogin(body: event.body);
      if (res.status == RepoResponseStatus.success) {
        emit(LoginSuccess(loginModel: res.response));
      } else {
        blocLog(msg: res.message ?? "", bloc: "LoginBloc");
        emit(LoginFailed(error: res.message ?? someWentWrong));
      }
    } catch (e) {
      blocLog(msg: e.toString(), bloc: "LoginBloc");
      emit(LoginFailed(error: e.toString()));
    }
  }

  FutureOr<void> _onGetSocialLogin(GetSocialLogin event, Emitter<LoginState> emit) async {
    try {
      emit(LoginSocialLoading());
      ResponseWrapper res = await getAuthRepo.userSocialLogin(body: event.body);
      if (res.status == RepoResponseStatus.success) {
        emit(LoginSuccess(loginModel: res.response));
      } else {
        blocLog(msg: res.message ?? "", bloc: "LoginBloc");
        emit(LoginFailed(error: res.message ?? someWentWrong));
      }
    } catch (e) {
      blocLog(msg: e.toString(), bloc: "LoginBloc");
      emit(LoginFailed(error: e.toString()));
    }
  }



}
