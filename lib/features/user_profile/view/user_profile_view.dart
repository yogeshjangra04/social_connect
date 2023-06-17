// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clonee/common/common.dart';
import 'package:twitter_clonee/constants/constants.dart';
import 'package:twitter_clonee/features/auth/controller/auth_controller.dart';
import 'package:twitter_clonee/features/user_profile/controller/user_profile_controller.dart';
import 'package:twitter_clonee/features/user_profile/widget/user_profile.dart';

import 'package:twitter_clonee/models/user_model.dart';

class UserProfileView extends ConsumerWidget {
  static route(UserModel userModel) => MaterialPageRoute(
        builder: (context) => UserProfileView(
          userModel: userModel,
        ),
      );
  final UserModel userModel;
  const UserProfileView({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel copyUser = userModel;
    final currUser = ref.watch(currentUserDetailsProvider).value;

    return Scaffold(
      body: currUser == null
          ? const Loader()
          : ref.watch(getLatestUserProfileDataProvider).when(
                data: (data) {
                  print(data.events);
                  if (data.events.contains(
                      'databases.*.collections.${AppwriteConstants.usersCollection}.documents.${copyUser.uid}.update')) {
                    copyUser = UserModel.fromMap(data.payload);
                  }
                  return UserProfile(user: copyUser);
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () {
                  return UserProfile(user: copyUser);
                },
              ),
    );
  }
}
