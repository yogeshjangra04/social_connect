// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clonee/common/common.dart';
import 'package:twitter_clonee/constants/constants.dart';
import 'package:twitter_clonee/core/enums/tweet_type_enum.dart';
import 'package:twitter_clonee/features/auth/controller/auth_controller.dart';
import 'package:twitter_clonee/features/tweet/widgets/carousel_image.dart';
import 'package:twitter_clonee/features/tweet/widgets/hashtag_text.dart';
import 'package:twitter_clonee/features/tweet/widgets/tweet_icon_button.dart';
import 'package:twitter_clonee/models/tweet_model.dart';
import 'package:twitter_clonee/theme/pallete.dart';
import 'package:timeago/timeago.dart' as timeago;

class TweetCard extends ConsumerWidget {
  final Tweet tweet;
  const TweetCard({
    required this.tweet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDetailsProvider(tweet.uid)).when(
        data: (user) => Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePic),
                        radius: 35,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // retweeted
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '@${user.name} .   ${timeago.format(tweet.tweetedAt, locale: 'en_short')}',
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Pallete.greyColor,
                                ),
                              ),
                            ],
                          ),
                          // replied to
                          HashtagText(text: tweet.text),
                          if (tweet.tweetType == TweetType.image)
                            CarouselImage(imageLinks: tweet.imageLinks),
                          if (tweet.link.isNotEmpty) ...[
                            const SizedBox(
                              height: 4,
                            ),
                            AnyLinkPreview(
                              displayDirection:
                                  UIDirection.uiDirectionHorizontal,
                              link: 'https://${tweet.link}',
                            ),
                          ],
                          Container(
                            margin: const EdgeInsets.only(top: 10, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TweetIconButton(
                                  pathname: AssetsConstants.viewsIcon,
                                  text: (tweet.commentIds.length +
                                          tweet.reshareCount +
                                          tweet.likes.length)
                                      .toString(),
                                  onTap: () {},
                                ),
                                TweetIconButton(
                                  pathname: AssetsConstants.retweetIcon,
                                  text: tweet.reshareCount.toString(),
                                  onTap: () {},
                                ),
                                TweetIconButton(
                                  pathname: AssetsConstants.commentIcon,
                                  text: tweet.commentIds.length.toString(),
                                  onTap: () {},
                                ),
                                TweetIconButton(
                                  pathname: AssetsConstants.likeOutlinedIcon,
                                  text: tweet.likes.length.toString(),
                                  onTap: () {},
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.share_outlined,
                                    size: 25,
                                    color: Pallete.greyColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Pallete.greyColor,
                  height: 8,
                ),
              ],
            ),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
