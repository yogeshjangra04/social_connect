import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clonee/common/common.dart';
import 'package:twitter_clonee/features/auth/controller/auth_controller.dart';
import 'package:twitter_clonee/features/notifications/notification_controller.dart';
import 'package:twitter_clonee/features/notifications/widgets/notification_tile.dart';
import 'package:twitter_clonee/models/notification_model.dart' as model;

import '../../../constants/constants.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currUser = ref.watch(currentUserDetailsProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: false,
      ),
      body: currUser == null
          ? const Loader()
          : ref.watch(getNotificationsProvider(currUser.uid)).when(
                data: (notifications) {
                  return ref.watch(latestNotificationsProvider).when(
                        data: (data) {
                          final latestNotification =
                              model.Notification.fromMap(data.payload);
                          bool isNotifPresent = false;
                          for (final notifs in notifications) {
                            if (notifs.id == latestNotification.id) {
                              isNotifPresent = true;
                              break;
                            }
                          }
                          if (!isNotifPresent &&
                              latestNotification.uid == currUser.uid) {
                            if (data.events.contains(
                                'databases.*.collections.${AppwriteConstants.notificationCollection}.documents.*.create')) {
                              notifications.insert(
                                  0, model.Notification.fromMap(data.payload));
                            }
                          }

                          return ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: ((context, index) {
                              final currNotifs = notifications[index];
                              return NotificationTile(notification: currNotifs);
                            }),
                          );
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () {
                          return ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: ((context, index) {
                              final currNotifs = notifications[index];
                              return NotificationTile(notification: currNotifs);
                            }),
                          );
                        },
                      );
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader(),
              ),
    );
  }
}
