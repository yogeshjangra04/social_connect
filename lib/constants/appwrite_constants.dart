class AppwriteConstants {
  static const String databaseId = "63fcfa92330e720a29f6";
  static const String projectId = "63fcf89298ee987d0394";
  static const String endPoint = "http://YOUR_IP:80/v1";
  static const String usersCollection = "63fe6d2990affb06445b";
  static const String tweetsCollection = "64183c27d26f6602d5b4";
  static const String imagesBucket = "641b54b2153ce2ded69d";
  static const String notificationCollection = "649945bb7c1e2c5a1f31";
  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
