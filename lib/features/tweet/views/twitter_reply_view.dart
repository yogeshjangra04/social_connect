// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clonee/features/tweet/controller/tweet_controller.dart';

import 'package:twitter_clonee/features/tweet/widgets/tweet_card.dart';

import '../../../common/common.dart';
import '../../../constants/constants.dart';
import '../../../models/tweet_model.dart';

class TwitterReplyScreen extends ConsumerWidget {
  static route(Tweet tweet) => MaterialPageRoute(
        builder: (context) => TwitterReplyScreen(tweet: tweet),
      );
  final Tweet tweet;
  const TwitterReplyScreen({
    super.key,
    required this.tweet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweet'),
      ),
      body: Column(
        children: [
          TweetCard(tweet: tweet),
          ref.watch(getRepliesToTweetsProvider(tweet)).when(
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
                          if (!isTweetPresent &&
                              latestTweet.repliedTo == tweet.id) {
                            if (data.events.contains(
                                'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create')) {
                              tweets.insert(0, Tweet.fromMap(data.payload));
                            } else if (data.events.contains(
                                'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.update')) {
                              final startingPoint =
                                  data.events[0].lastIndexOf('documents.');
                              final endingPoint =
                                  data.events[0].lastIndexOf('.update');
                              final tweetId = data.events[0]
                                  .substring(startingPoint + 10, endingPoint);
                              var tweet = tweets
                                  .where((element) => element.id == tweetId)
                                  .first;
                              final tweetIndex = tweets.indexOf(tweet);
                              tweets.removeWhere(
                                  (element) => element.id == tweetId);
                              tweet = Tweet.fromMap(data.payload);
                              tweets.insert(tweetIndex, tweet);
                            }
                          }

                          return Expanded(
                            child: ListView.builder(
                              itemCount: tweets.length,
                              itemBuilder: ((context, index) {
                                final tweet = tweets[index];
                                return TweetCard(tweet: tweet);
                              }),
                            ),
                          );
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: tweets.length,
                              itemBuilder: ((context, index) {
                                final tweet = tweets[index];
                                return TweetCard(tweet: tweet);
                              }),
                            ),
                          );
                        },
                      );
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader(),
              ),
        ],
      ),
      bottomNavigationBar: TextField(
        onSubmitted: (value) {
          ref.read(tweetControllerProvider.notifier).sharetweet(
              images: [],
              text: value,
              context: context,
              repliedTo: tweet.id,
              repliedToUserId: tweet.uid);
        },
        decoration: const InputDecoration(hintText: 'Tweet your reply'),
      ),
    );
  }
}
