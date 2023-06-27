// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:twitter_clonee/core/enums/notification_type_enum.dart';

class Notification {
  final String postId;
  final String id;
  final String text;
  final String uid;
  final NotificationType notificationType;
  Notification({
    required this.postId,
    required this.id,
    required this.text,
    required this.uid,
    required this.notificationType,
  });

  Notification copyWith({
    String? postId,
    String? id,
    String? text,
    String? uid,
    NotificationType? notificationType,
  }) {
    return Notification(
      postId: postId ?? this.postId,
      id: id ?? this.id,
      text: text ?? this.text,
      uid: uid ?? this.uid,
      notificationType: notificationType ?? this.notificationType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postId': postId,
      'text': text,
      'uid': uid,
      'notificationType': notificationType.type,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      postId: map['postId'] as String,
      id: map['\$id'] as String,
      text: map['text'] as String,
      uid: map['uid'] as String,
      notificationType:
          (map['notificationType'] as String).toNotificationTypeEnum(),
    );
  }

  @override
  String toString() {
    return 'Notification(postId: $postId, id: $id, text: $text, uid: $uid, notificationType: $notificationType)';
  }

  @override
  bool operator ==(covariant Notification other) {
    if (identical(this, other)) return true;

    return other.postId == postId &&
        other.id == id &&
        other.text == text &&
        other.uid == uid &&
        other.notificationType == notificationType;
  }

  @override
  int get hashCode {
    return postId.hashCode ^
        id.hashCode ^
        text.hashCode ^
        uid.hashCode ^
        notificationType.hashCode;
  }
}
