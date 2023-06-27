import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clonee/apis/notification_api.dart';
import 'package:twitter_clonee/core/enums/notification_type_enum.dart';
import 'package:twitter_clonee/core/providers.dart';
import 'package:twitter_clonee/models/notification_model.dart' as model;

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, bool>(
  (ref) {
    return NotificationController(
      notificationAPI: ref.watch(notificationAPIProvider),
    );
  },
);
final latestNotificationsProvider = StreamProvider((ref) {
  final notificationAPI = ref.watch(notificationAPIProvider);
  Realtime realtime = Realtime(ref.watch(appwriteClientProvider));
  return notificationAPI.latestNotifications(realtime);
});
final getNotificationsProvider = FutureProvider.family((ref, String uid) async {
  final notificationController =
      ref.watch(notificationControllerProvider.notifier);
  return notificationController.getNotifications(uid);
});

class NotificationController extends StateNotifier<bool> {
  final NotificationAPI _notificationAPI;
  NotificationController({required NotificationAPI notificationAPI})
      : _notificationAPI = notificationAPI,
        super(false);

  void createNotification(
      {required String text,
      required String postID,
      required String uid,
      required NotificationType notificationType}) async {
    model.Notification notification = model.Notification(
        postId: postID,
        id: '',
        text: text,
        uid: uid,
        notificationType: notificationType);
    await _notificationAPI.createNotification(notification);
  }

  Future<List<model.Notification>> getNotifications(String uid) async {
    final res = await _notificationAPI.getNotifications(uid);
    return res.map((e) => model.Notification.fromMap(e.data)).toList();
  }
}
