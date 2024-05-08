part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
}

class GetNotificationList extends NotificationEvent {
  final bool? more;
  const GetNotificationList({ this.more});

  @override
  List<Object?> get props => [more];
}
