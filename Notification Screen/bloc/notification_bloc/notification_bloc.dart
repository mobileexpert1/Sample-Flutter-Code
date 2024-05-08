import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:player_league/business_logic/models/response_wrapper.dart';
import 'package:player_league/screens/notification_screen/models/notification_model.dart';
import 'package:player_league/utils/services/all_getter.dart';
import 'package:player_league/utils/services/helpers.dart';

part 'notification_event.dart';

part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  int page = 1;
  List<NotificationListItem>? notificationList = <NotificationListItem>[];

  NotificationBloc() : super(NotificationInitial()) {
    on<GetNotificationList>(_onGetNotificationList);
  }

  Future<FutureOr<void>> _onGetNotificationList(
      GetNotificationList event, Emitter<NotificationState> emit) async {
    try {
      emit(NotificationLoading(showMoreLoading: (event.more ?? false)));
      if (event.more ?? false) {
        page++;
      } else {
        page = 1;
        notificationList?.clear();
      }
      final res = await getGeneralRepo.getNotification(page: page);
      if (res.status == RepoResponseStatus.success) {
        final model = (res.response as NotificationDetailModel);
        model.list?.forEach((element) {
          notificationList?.add(element);
        });
        notificationList?.toSet().toList();
        blocLog(
            msg: (model.list?.length ?? 0).toString(),
            bloc: "NotificationBloc");
        emit(
          NotificationLoaded(
              notificationList: notificationList,
              page: page,
              totalPage: model.pagination?.totalPages ?? 1),
        );
      } else {
        emit(NotificationFailed(error: res.message ?? someWentWrong));
      }
    } catch (e, s) {
      blocLog(msg: e.toString(), bloc: "NotificationBloc");
      blocLog(msg: s.toString(), bloc: "NotificationBloc");
      emit(NotificationFailed(error: e.toString()));
    }
  }
}
