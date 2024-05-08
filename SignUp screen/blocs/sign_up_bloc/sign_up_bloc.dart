import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../business_logic/models/response_wrapper.dart';
import '../../../../utils/services/all_getter.dart';
import '../../../../utils/services/constents.dart';
import '../../../../utils/services/helpers.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<GetSignUp>(_onSignUp);
  }

  Future<FutureOr<void>> _onSignUp(
    GetSignUp event,
    Emitter<SignUpState> emit,
  ) async {
    try {
      emit(SignUpLoading());
      final potion = await currentPosition();
      final address = await getAddress(potion);
      final fcmToken = await getFcmToken();
      Map<String, dynamic> map = event.body;
        map[BodyConst.latitude] = potion?.latitude ?? "";
        map[BodyConst.longitude] = potion?.longitude ?? "";
        map[BodyConst.city] = address?.city??"";
        map[BodyConst.address] = address?.address??"";
      map[BodyConst.fcmToken] = fcmToken;
      ResponseWrapper res = await getAuthRepo.userRegister(body: map);
      if (res.status == RepoResponseStatus.success) {
        emit(SignUpSuccess(email:event.body[BodyConst.email] ));
      } else {
        emit(SignUpFailed(error: res.message ?? someWentWrong));
      }
    } catch (e, t) {
      blocLog(msg: e.toString(), bloc: "SignUpBloc");
      blocLog(msg: t.toString(), bloc: "SignUpBloc");
      emit(SignUpFailed(error: e.toString()));
    }
  }
}
