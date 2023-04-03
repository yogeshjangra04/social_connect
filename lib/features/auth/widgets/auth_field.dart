import 'package:flutter/material.dart';
import 'package:twitter_clonee/theme/pallete.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const AuthField({Key? key, required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Pallete.blueColor,
              width: 3,
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Pallete.greyColor,
            )),
        hintText: label,
        contentPadding: EdgeInsets.all(22),
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
    );
  }
}
