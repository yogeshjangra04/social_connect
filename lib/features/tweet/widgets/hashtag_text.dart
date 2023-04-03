// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:twitter_clonee/theme/theme.dart';

class HashtagText extends StatelessWidget {
  final String text;
  const HashtagText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textspans = [];
    text.split(' ').forEach(
      (element) {
        if (element.startsWith('#')) {
          textspans.add(
            TextSpan(
              text: '$element ',
              style: const TextStyle(
                color: Pallete.blueColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else if (element.startsWith('www.') ||
            element.startsWith('https://')) {
          textspans.add(
            TextSpan(
              text: '$element ',
              style: const TextStyle(
                color: Pallete.blueColor,
                fontSize: 18,
              ),
            ),
          );
        } else {
          textspans.add(
            TextSpan(
              text: '$element ',
              style: const TextStyle(
                // color: Pallete.whiteColor,
                fontSize: 18,
              ),
            ),
          );
        }
      },
    );
    return RichText(text: TextSpan(children: textspans));
  }
}
