import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:player_league/screens/common_widgets/dialog/dialogs.dart';
import 'package:player_league/screens/common_widgets/shimmer.dart';
import 'package:player_league/screens/notification_screen/bloc/notification_bloc/notification_bloc.dart';
import 'package:player_league/screens/notification_screen/models/notification_model.dart';
import 'package:player_league/utils/color_res.dart';
import 'package:player_league/utils/common_ui.dart';
import 'package:player_league/utils/fonts.dart';
import 'package:player_league/utils/services/helpers.dart';

void openNotificationSheet(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const NotificationListScreen();
    },
  );
}

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({Key? key}) : super(key: key);

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  List<NotificationListItem>? notificationList;
  int page = 1;
  int totalPage = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: transparent,
        body: BlocConsumer<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (state is NotificationLoaded) {
              notificationList = state.notificationList;
              page = state.page;
              totalPage = state.totalPage;
            }
          },
          builder: (context, state) {
            printLog("$state");
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: MediaQuery.of(context).size.height / 1.8,
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.amber, //New
                            blurRadius: 0.0,
                            offset: Offset(0, 0.8))
                      ],
                      color: primary,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(52)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        yHeight(screenHeight(context) / 13),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: SizedBox()),
                            Expanded(child: SizedBox()),
                            Text(
                              'Notifications',
                              style: TextStyle(
                                color: white,
                                fontFamily: Fonts.bold,
                                fontSize: 24,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: ColorRes.colorCyan,
                                  size: 30,
                                )),
                          ],
                        ),
                        yHeight(20),
                        if (state is NotificationFailed) ...{
                          Center(
                            child: NotDataFoundRefresh(
                              message: state.error,
                              onTap: () {
                                context.read<NotificationBloc>().add(const GetNotificationList());
                              },
                            ),
                          ),
                        } else if ((state is NotificationLoading) && (!state.showMoreLoading)) ...{
                          customListViewShimmer(itemCount: 4, borderRadius: 20)
                        } else ...{
                          showNotificationList(context, state),
                        }
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        back(context);
                      },
                      child: Container(
                        color: Colors.transparent,
                      )),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget showNotificationList(BuildContext context, NotificationState state) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: notificationList?.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => notification(
                  context: context,
                  state: state,
                  isLast: notificationList?.last.gameId == notificationList?[index].gameId,
                  notification: notificationList?[index],
                  index: index,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget notification(
      {required BuildContext context,
      NotificationListItem? notification,
      required NotificationState state,
      bool? isLast,
      required int index}) {
    printLog(notification?.toJson());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () { },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${index + 1}  ${notification?.title}" ?? "",
                  style: TextStyle(color: white, fontFamily: Fonts.semiBold, fontSize: 14),
                ),
                yHeight(10),
                Text(
                  DateFormat("MMMM dd,yyyy").format(notification?.createdAt ?? DateTime.now()),
                  style: const TextStyle(color: Color(0xffF5F7F7), fontFamily: Fonts.regular, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        if ((!(page == totalPage)) && (isLast ?? false)) ...{
          if ((state is NotificationLoading) && (state.showMoreLoading)) ...{
            Align(
              alignment: Alignment.bottomRight,
              child: customLoader(),
            ),
          } else ...{
            InkWell(
              onTap: () {
                context.read<NotificationBloc>().add(const GetNotificationList(more: true));
              },
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  "more",
                  style: TextStyle(color: white, fontSize: 16),
                ),
              ),
            )
          }
        }
      ],
    );
  }
}
