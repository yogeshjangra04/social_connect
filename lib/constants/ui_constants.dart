import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clonee/constants/constants.dart';
import 'package:twitter_clonee/features/tweet/widgets/tweet_list.dart';
import 'package:twitter_clonee/theme/theme.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(AssetsConstants.twitterLogo,
          color: Pallete.blueColor, height: 30),
      centerTitle: true,
    );
  }

  static const List<Widget> bottomTabBarPages = [
    TweetList(),
    Text("Search Screen"),
    Text("Notification screen"),
  ];
}
