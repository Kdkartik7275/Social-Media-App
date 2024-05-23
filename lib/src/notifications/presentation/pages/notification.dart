import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_x/core/common/widgets/appbar/appbar.dart';
import 'package:social_x/core/common/widgets/indicators/indicators.dart';
import 'package:social_x/src/notifications/presentation/cubit/notification_cubit.dart';
import 'package:social_x/src/notifications/presentation/widgets/activity_item.dart';
import 'package:social_x/src/user/presentation/bloc/cubit/currentuser_cubit.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final me =
        BlocProvider.of<CurrentuserCubit>(context).state as CurrentuserLoaded;
    return Scaffold(
      appBar: const TAppBar(
        title: Text("Notifications"),
      ),
      body: StreamBuilder(
          stream: context
              .read<NotificationCubit>()
              .listenToNotifcations(myUserId: me.user.id!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final notifications = snapshot.data!;
              if (notifications.isEmpty) {
                return const Center(
                  child: Text("No Notifications"),
                );
              }
              context
                  .read<NotificationCubit>()
                  .updateSeenStatus(myUserId: me.user.id!);
              return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return ActivityItem(
                      notification: notifications[index],
                    );
                  });
            }
            return circularProgress(context);
          }),
    );
  }
}
