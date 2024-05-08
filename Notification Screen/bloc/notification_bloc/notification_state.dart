part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
}

class NotificationInitial extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationLoading extends NotificationState {
  final bool showMoreLoading;

  NotificationLoading({required this.showMoreLoading});
  @override
  List<Object> get props => [showMoreLoading];
}

class NotificationLoaded extends NotificationState {
  final List<NotificationListItem>?notificationList;
  final int page;
  final int totalPage;

  const NotificationLoaded(
      {required this.page, required this.notificationList, required this.totalPage});

  @override
  List<Object?> get props => [notificationList, page,totalPage];
}

class NotificationFailed extends NotificationState {
  final String error;

  const NotificationFailed({required this.error});

  @override
  List<Object> get props => [
        error,
      ];
}
