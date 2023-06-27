import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clonee/constants/constants.dart';
import 'package:twitter_clonee/core/core.dart';
import 'package:twitter_clonee/core/providers.dart';

import '../models/notification_model.dart';

final notificationAPIProvider = Provider((ref) {
  return NotificationAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime3: ref.watch(appwriteReal3timeProvider),
  );
});

abstract class INotificationAPI {
  FutureEitherVoid createNotification(Notification notification);
  Future<List<Document>> getNotifications(String uid);
  Stream<RealtimeMessage> latestNotifications(Realtime realtime);
}

class NotificationAPI implements INotificationAPI {
  final Databases _db;
  final Realtime _realtime3;

  NotificationAPI({required Databases db, required Realtime realtime3})
      : _db = db,
        _realtime3 = realtime3;
  @override
  FutureEitherVoid createNotification(Notification notification) async {
    try {
      await _db.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.notificationCollection,
          documentId: ID.unique(),
          data: notification.toMap());

      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'An unexpected error occured',
          st,
        ),
      );
    } catch (e, st) {
      return left(
        Failure(
          e.toString(),
          st,
        ),
      );
    }
  }

  @override
  Future<List<Document>> getNotifications(String uid) async {
    final res = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.notificationCollection,
        queries: [
          Query.equal('uid', uid),
        ]);

    return res.documents;
  }

  @override
  Stream<RealtimeMessage> latestNotifications(Realtime realtime) {
    return realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.notificationCollection}.documents'
    ]).stream;
  }
}
