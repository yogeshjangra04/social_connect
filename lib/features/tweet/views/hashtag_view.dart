import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clonee/common/common.dart';
import 'package:twitter_clonee/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clonee/features/tweet/widgets/tweet_card.dart';

class HashTagView extends ConsumerWidget {
  static route(String hashtag) => MaterialPageRoute(
        builder: (context) => HashTagView(hashtag: hashtag),
      );
  final String hashtag;
  const HashTagView({super.key, required this.hashtag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweets By Hashtag'),
        centerTitle: false,
      ),
      body: ref.watch(getTweetsByHashtagProvider(hashtag)).when(
            data: (tweets) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tweet = tweets[index];
                  return TweetCard(tweet: tweet);
                },
                itemCount: tweets.length,
              );
            },
            error: (error, st) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          ),
    );
  }
}
