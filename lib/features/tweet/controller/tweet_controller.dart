import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clonee/apis/notification_api.dart';
import 'package:twitter_clonee/apis/storage_api.dart';
import 'package:twitter_clonee/apis/tweet_api.dart';
import 'package:twitter_clonee/core/enums/notification_type_enum.dart';
import 'package:twitter_clonee/core/enums/tweet_type_enum.dart';
import 'package:twitter_clonee/core/utils.dart';
import 'package:twitter_clonee/features/auth/controller/auth_controller.dart';
import 'package:twitter_clonee/features/notifications/notification_controller.dart';
import 'package:twitter_clonee/models/tweet_model.dart';
import 'package:twitter_clonee/models/user_model.dart';

final tweetControllerProvider = StateNotifierProvider<TweetController, bool>(
  (ref) {
    return TweetController(
      ref: ref,
      tweetAPI: ref.watch(tweetAPIProvider),
      storageAPI: ref.watch(storageAPIProvider),
      notificationController:
          ref.watch(notificationControllerProvider.notifier),

      // notificationController:
      //     ref.watch(notificationControllerProvider.notifier),
    );
  },
);
final getTweetsProvider = FutureProvider((ref) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});
final getLatestTweetProvider = StreamProvider.autoDispose((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  return tweetAPI.getLatestTweet();
});
final getRepliesToTweetsProvider = FutureProvider.family((ref, Tweet tweet) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getRepliesToTweet(tweet);
});
final getTweetByIdProvider = FutureProvider.family((ref, String id) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetById(id);
});
final getTweetsByHashtagProvider = FutureProvider.family((ref, String hashtag) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetsByHashtag(hashtag);
});

class TweetController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final Ref _ref;
  final StorageAPI _storageAPI;
  final NotificationController _notificationController;
  TweetController({
    required Ref ref,
    required TweetAPI tweetAPI,
    required StorageAPI storageAPI,
    required NotificationController notificationController,
  })  : _ref = ref,
        _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        _notificationController = notificationController,
        super(false);

  Future<List<Tweet>> getTweets() async {
    final tweetList = await _tweetAPI.getTweets();
    return tweetList.map((e) => Tweet.fromMap(e.data)).toList();
  }

  void sharetweet(
      {required List<File> images,
      required String text,
      required BuildContext context,
      required String repliedTo,
      required String repliedToUserId}) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please enter text');
      return;
    }

    if (images.isNotEmpty) {
      _shareImageTweet(
          images: images,
          text: text,
          context: context,
          repliedTo: repliedTo,
          repliedToUserId: repliedToUserId);
    } else {
      _shareTextTweet(
          text: text,
          context: context,
          repliedTo: repliedTo,
          repliedToUserId: repliedToUserId);
    }
  }

  void _shareTextTweet(
      {required String text,
      required BuildContext context,
      required String repliedTo,
      required String repliedToUserId}) async {
    state = true;
    String link = _getLinkFromText(text);
    final hashtags = _getHashtagsFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    Tweet tweet = Tweet(
        text: text,
        hashtags: hashtags,
        link: link,
        imageLinks: [],
        uid: user.uid,
        tweetType: TweetType.text,
        tweetedAt: DateTime.now(),
        likes: [],
        commentIds: [],
        id: '',
        reshareCount: 0,
        retweetedBy: '',
        repliedTo: repliedTo);
    final res = await _tweetAPI.shareTweet(tweet);

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        if (repliedToUserId.isNotEmpty) {
          _notificationController.createNotification(
              text: "${user.name} replied to you",
              postID: r.$id,
              uid: repliedToUserId,
              notificationType: NotificationType.reply);
        }
      },
    );
    state = false;
  }

  void _shareImageTweet(
      {required List<File> images,
      required String text,
      required BuildContext context,
      required String repliedTo,
      required String repliedToUserId}) async {
    state = true;
    String link = _getLinkFromText(text);
    final hashtags = _getHashtagsFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    final imageLinks = await _storageAPI.uploadImage(images);
    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: imageLinks,
      uid: user.uid,
      tweetType: TweetType.image,
      tweetedAt: DateTime.now(),
      likes: [],
      commentIds: [],
      id: '',
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
    );
    final res = await _tweetAPI.shareTweet(tweet);

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        if (repliedToUserId.isNotEmpty) {
          _notificationController.createNotification(
              text: "${user.name} replied to you",
              postID: r.$id,
              uid: repliedToUserId,
              notificationType: NotificationType.reply);
        }
      },
    );
    state = false;
  }

  String _getLinkFromText(String text) {
    String link = '';
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> hashtags = [];
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }

  void likeTweet(Tweet tweet, UserModel user) async {
    List<String> likes = tweet.likes;
    if (tweet.likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }
    tweet = tweet.copyWith(likes: likes);
    final res = await _tweetAPI.likeTweet(tweet);
    return res.fold((l) => null, (r) {
      _notificationController.createNotification(
        text: '${user.name} liked your tweet!',
        postID: tweet.id,
        uid: tweet.uid,
        notificationType: NotificationType.like,
      );
    });
  }

  void reshareTweet(
      Tweet tweet, UserModel currUser, BuildContext context) async {
    tweet = tweet.copyWith(
      reshareCount: tweet.reshareCount + 1,
    );
    final res = await _tweetAPI.updateReshareCount(tweet);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        tweet = tweet.copyWith(
          reshareCount: 0,
          tweetedAt: DateTime.now(),
          retweetedBy: currUser.name,
          likes: [],
          commentIds: [],
          id: ID.unique(),
        );
        final res2 = await _tweetAPI.shareTweet(tweet);
        res2.fold(
          (l) => showSnackBar(context, l.message),
          (r) {
            _notificationController.createNotification(
                text: "${currUser.name} reshared your tweet",
                postID: tweet.id,
                uid: tweet.uid,
                notificationType: NotificationType.retweet);
            showSnackBar(context, 'Rewtweeted!');
          },
        );
      },
    );
  }

  Future<List<Tweet>> getRepliesToTweet(Tweet tweet) async {
    final tweets = await _tweetAPI.getRepliesToTweet(tweet);
    return tweets.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  Future<Tweet> getTweetById(String id) async {
    final tweet = await _tweetAPI.getTweetById(id);
    return Tweet.fromMap(tweet.data);
  }

  Future<List<Tweet>> getTweetsByHashtag(String hashtag) async {
    final tweets = await _tweetAPI.getTweetByHashtag(hashtag);
    return tweets.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }
}
