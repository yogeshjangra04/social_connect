// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:twitter_clonee/theme/theme.dart';

class FollowCount extends StatelessWidget {
  final String text;
  final int count;
  const FollowCount({
    Key? key,
    required this.text,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 18,
            color: Pallete.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Pallete.greyColor,
          ),
        ),
      ],
    );
  }
}
