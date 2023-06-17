import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clonee/common/common.dart';
import 'package:twitter_clonee/features/auth/controller/auth_controller.dart';
import 'package:twitter_clonee/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clonee/features/user_profile/controller/user_profile_controller.dart';
import 'package:twitter_clonee/features/user_profile/view/edit_profile_view.dart';
import 'package:twitter_clonee/features/user_profile/widget/follow_count.dart';
import 'package:twitter_clonee/models/user_model.dart';
import 'package:twitter_clonee/theme/pallete.dart';

class UserProfile extends ConsumerWidget {
  final UserModel user;
  const UserProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const Loader()
        : DefaultTextStyle(
            style: const TextStyle(decoration: TextDecoration.none),
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 150,
                    snap: true,
                    floating: true,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: user.bannerPic.isEmpty
                              ? Container(
                                  color: Pallete.blueColor,
                                )
                              : Image.network(
                                  user.bannerPic,
                                  fit: BoxFit.fitWidth,
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(user.profilePic),
                            radius: 50,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: OutlinedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                  color: Pallete.whiteColor,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                              ),
                            ),
                            onPressed: () {
                              if (currentUser.uid == user.uid) {
                                Navigator.push(
                                    context, EditProfileView.route());
                              } else {
                                ref
                                    .read(
                                        userProfileControllerProvider.notifier)
                                    .followUser(
                                      user: user,
                                      context: context,
                                      currUser: currentUser,
                                    );
                              }
                            },
                            child: Text(
                              currentUser.uid == user.uid
                                  ? 'Edit Profile'
                                  : currentUser.following.contains(user.uid)
                                      ? 'Unfollow'
                                      : 'Follow',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.all(8),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Text(
                            user.name,
                            style: const TextStyle(
                                color: Pallete.whiteColor,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '@${user.name}',
                            style: const TextStyle(
                              color: Pallete.greyColor,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            user.bio,
                            style: const TextStyle(
                              color: Pallete.whiteColor,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              FollowCount(
                                text: 'Followers',
                                count: user.followers.length - 1,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              FollowCount(
                                text: 'Following',
                                count: user.following.length - 1,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          const Divider(
                            color: Pallete.whiteColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: ref.watch(getUserTweetsProvider(user.uid)).when(
                    data: (tweets) {
                      return ListView.builder(
                        itemCount: tweets.length,
                        itemBuilder: ((context, index) {
                          final tweet = tweets[index];
                          return TweetCard(tweet: tweet);
                        }),
                      );
                    },
                    error: (error, stackTrace) => ErrorText(
                      error: error.toString(),
                    ),
                    loading: () => const Loader(),
                  ),
            ),
          );
  }
}
