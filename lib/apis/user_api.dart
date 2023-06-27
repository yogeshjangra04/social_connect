import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clonee/constants/constants.dart';
import 'package:twitter_clonee/core/core.dart';
import 'package:twitter_clonee/core/providers.dart';

import '../models/user_model.dart';
// import 'package:twitter_clone/models/user_model.dart';

final userAPIProvider = Provider((ref) {
  return UserAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtimes: ref.watch(appwriteReal2timeProvider),
  );
});

abstract class IUserAPI {
  FutureEitherVoid saveUserData(UserModel userModel);
  Future<model.Document> getUserData(String uid);
  Future<List<model.Document>> searchUserByName(String name);
  FutureEitherVoid updateUserData(UserModel userModel);
  Stream<RealtimeMessage> getLatestUserProfileData(
      String uid, Realtime realtime);
  FutureEitherVoid followUser(UserModel user);
  FutureEitherVoid addToFollowing(UserModel user);
}

class UserAPI implements IUserAPI {
  final Databases _db;
  final Realtime _realtimes;

  UserAPI({
    required Databases db,
    // required Realtime realtime,
    required Realtime realtimes,
  })  : _db = db,
        // _realtime = realtime;
        _realtimes = realtimes;

  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<model.Document> getUserData(String uid) {
    return _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollection,
      documentId: uid,
    );
  }

  @override
  Future<List<model.Document>> searchUserByName(String name) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollection,
      queries: [
        Query.search('name', name),
      ],
    );

    return documents.documents;
  }

  @override
  FutureEitherVoid updateUserData(UserModel userModel) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Stream<RealtimeMessage> getLatestUserProfileData(
      String uid, Realtime realtime) {
    return realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.usersCollection}.documents.$uid'
    ]).stream;
  }

  @override
  FutureEitherVoid addToFollowing(UserModel user) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: user.uid,
        data: {
          'following': user.following,
        },
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEitherVoid followUser(UserModel user) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: user.uid,
        data: {
          'followers': user.followers,
        },
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

//   @override
//   FutureEitherVoid updateUserData(UserModel userModel) async {
//     try {
//       await _db.updateDocument(
//         databaseId: AppwriteConstants.databaseId,
//         collectionId: AppwriteConstants.usersCollection,
//         documentId: userModel.uid,
//         data: userModel.toMap(),
//       );
//       return right(null);
//     } on AppwriteException catch (e, st) {
//       return left(
//         Failure(
//           e.message ?? 'Some unexpected error occurred',
//           st,
//         ),
//       );
//     } catch (e, st) {
//       return left(Failure(e.toString(), st));
//     }
//   }

//   @override
//   Stream<RealtimeMessage> getLatestUserProfileData() {
//     return _realtime.subscribe([
//       'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.usersCollection}.documents'
//     ]).stream;
//   }

//   @override
//   FutureEitherVoid followUser(UserModel user) async {
//     try {
//       await _db.updateDocument(
//         databaseId: AppwriteConstants.databaseId,
//         collectionId: AppwriteConstants.usersCollection,
//         documentId: user.uid,
//         data: {
//           'followers': user.followers,
//         },
//       );
//       return right(null);
//     } on AppwriteException catch (e, st) {
//       return left(
//         Failure(
//           e.message ?? 'Some unexpected error occurred',
//           st,
//         ),
//       );
//     } catch (e, st) {
//       return left(Failure(e.toString(), st));
//     }
//   }

//   @override
//   FutureEitherVoid addToFollowing(UserModel user) async {
//     try {
//       await _db.updateDocument(
//         databaseId: AppwriteConstants.databaseId,
//         collectionId: AppwriteConstants.usersCollection,
//         documentId: user.uid,
//         data: {
//           'following': user.following,
//         },
//       );
//       return right(null);
//     } on AppwriteException catch (e, st) {
//       return left(
//         Failure(
//           e.message ?? 'Some unexpected error occurred',
//           st,
//         ),
//       );
//     } catch (e, st) {
//       return left(Failure(e.toString(), st));
//     }
//   }
}
