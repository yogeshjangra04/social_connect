// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clonee/features/user_profile/view/user_profile_view.dart';
import 'package:twitter_clonee/features/user_profile/widget/user_profile.dart';

import 'package:twitter_clonee/models/user_model.dart';
import 'package:twitter_clonee/theme/pallete.dart';

class SearchTile extends StatelessWidget {
  final UserModel user;
  const SearchTile({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context, UserProfileView.route(user));
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.profilePic),
      ),
      title: Text(
        user.name,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '@${user.name}',
            style: const TextStyle(fontSize: 16, color: Pallete.greyColor),
          ),
          Text(
            user.bio,
            style: const TextStyle(fontSize: 16, color: Pallete.greyColor),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
