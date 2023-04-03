import 'package:flutter/material.dart';
import 'package:twitter_clonee/theme/pallete.dart';

class RoundedSmallButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final backgroundColor;
  final textColor;
  const RoundedSmallButton({
    Key? key,
    required this.onTap,
    required this.text,
    this.backgroundColor = Pallete.whiteColor,
    this.textColor = Pallete.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      radius: 12,
      onTap: onTap,
      child: Chip(
        label: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
        backgroundColor: backgroundColor,
        labelPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      ),
    );
  }
}
