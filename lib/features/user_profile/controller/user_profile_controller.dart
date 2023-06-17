import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clonee/apis/storage_api.dart';
import 'package:twitter_clonee/apis/tweet_api.dart';
import 'package:twitter_clonee/apis/user_api.dart';
import 'package:twitter_clonee/core/utils.dart';
import 'package:twitter_clonee/models/tweet_model.dart';
import 'package:twitter_clonee/models/user_model.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    userAPI: ref.watch(
      userAPIProvider,
    ),
    storageAPI: ref.watch(
      storageAPIProvider,
    ),
    tweetAPI: ref.watch(
      tweetAPIProvider,
    ),
  );
});
final getUserTweetsProvider = FutureProvider.family((ref, String uid) async {
  final userProfileController =
      ref.watch(userProfileControllerProvider.notifier);
  return userProfileController.getUserTweets(uid);
});
final getLatestUserProfileDataProvider = StreamProvider.autoDispose((ref) {
  final userAPI = ref.watch(userAPIProvider);
  return userAPI.getLatestUserProfileData();
});

class UserProfileController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  final UserAPI _userAPI;
  UserProfileController({
    required TweetAPI tweetAPI,
    required StorageAPI storageAPI,
    required UserAPI userAPI,
  })  : _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        _userAPI = userAPI,
        super(false);

  Future<List<Tweet>> getUserTweets(String uid) async {
    final tweets = await _tweetAPI.getUserTweets(uid);
    return tweets.map((e) => Tweet.fromMap(e.data)).toList();
  }

  void updateUserData({
    required UserModel userModel,
    required BuildContext context,
    required File? bannerFile,
    required File? profileFile,
  }) async {
    state = true;
    if (bannerFile != null) {
      final bannerUrl = await _storageAPI.uploadImage([bannerFile]);
      userModel.copyWith(bannerPic: bannerUrl[0]);
    }
    if (profileFile != null) {
      final profileUrl = await _storageAPI.uploadImage([profileFile]);
      userModel.copyWith(profilePic: profileUrl[0]);
    }
    final res = await _userAPI.updateUserData(userModel);
    state = false;
    res.fold(
      (l) => showSnackBar(
        context,
        l.message,
      ),
      (r) => null,
    );
  }

  void followUser({
    required UserModel user,
    required BuildContext context,
    required UserModel currUser,
  }) async {
    if (currUser.following.contains(user.uid)) {
      currUser.following.remove(user.uid);
      user.followers.remove(currUser.uid);
    } else {
      currUser.following.add(user.uid);
      user.followers.add(currUser.uid);
    }
    user = user.copyWith(followers: user.followers);
    currUser = currUser.copyWith(following: currUser.following);
    final res1 = await _userAPI.followUser(user);
    res1.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        final res2 = await _userAPI.addToFollowing(currUser);
        res2.fold(
          (l) => showSnackBar(context, l.message),
          (r) => null,
        );
      },
    );
  }
}
