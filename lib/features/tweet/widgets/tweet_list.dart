import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clonee/common/common.dart';
import 'package:twitter_clonee/features/auth/controller/auth_controller.dart';
import 'package:twitter_clonee/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clonee/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clonee/models/tweet_model.dart';

import '../../../constants/constants.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currUser = ref.watch(currentUserDetailsProvider).value;
    if (currUser == null) return const Text("NUll");
    return ref.watch(getTweetsProvider).when(
        data: (tweets) {
          return ref.watch(getLatestTweetProvider).when(
              data: (data) {
                final latestTweet = Tweet.fromMap(data.payload);
                bool isTweetPresent = false;
                for (final tweetModel in tweets) {
                  if (tweetModel.id == latestTweet.id) {
                    isTweetPresent = true;
                    break;
                  }
                }
                if (!isTweetPresent) {
                  if (data.events.contains(
                      'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create')) {
                    tweets.insert(0, Tweet.fromMap(data.payload));
                  } else if (data.events.contains(
                      'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.update')) {
                    final startingPoint =
                        data.events[0].lastIndexOf('documents.');
                    final endingPoint = data.events[0].lastIndexOf('.update');
                    final tweetId = data.events[0]
                        .substring(startingPoint + 10, endingPoint);
                    var tweet =
                        tweets.where((element) => element.id == tweetId).first;
                    final tweetIndex = tweets.indexOf(tweet);
                    tweets.removeWhere((element) => element.id == tweetId);
                    tweet = Tweet.fromMap(data.payload);
                    tweets.insert(tweetIndex, tweet);
                  }
                }

                return ListView.builder(
                  itemCount: tweets.length,
                  itemBuilder: ((context, index) {
                    final tweet = tweets[index];
                    return TweetCard(tweet: tweet);
                  }),
                );
              },
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () {
                return ListView.builder(
                  itemCount: tweets.length,
                  itemBuilder: ((context, index) {
                    final tweet = tweets[index];
                    return TweetCard(tweet: tweet);
                  }),
                );
              });
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
