// import 'dart:js';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clonee/common/loading_page.dart';
import 'package:twitter_clonee/features/auth/controller/auth_controller.dart';
import 'package:twitter_clonee/features/auth/view/login_view.dart';
import 'package:twitter_clonee/features/auth/widgets/auth_field.dart';

import '../../../common/rounded_small_button.dart';
import '../../../constants/constants.dart';
import '../../../theme/theme.dart';

class SignUpView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpView(),
      );
  const SignUpView({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final appBar = UIConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onSignUp() {
    ref.read(authControllerProvider.notifier).signUp(
        email: emailController.text,
        password: passwordController.text,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: appBar,
      body: isLoading
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      AuthField(
                          controller: emailController, label: "Email Address"),
                      SizedBox(
                        height: 25,
                      ),
                      AuthField(
                          controller: passwordController, label: "Password"),
                      SizedBox(height: 15),
                      Align(
                        alignment: Alignment.topRight,
                        child:
                            RoundedSmallButton(onTap: onSignUp, text: "Create"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      RichText(
                        text: TextSpan(
                            text: "Have an Account?",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Pallete.whiteColor,
                            ),
                            children: [
                              TextSpan(
                                text: "  Login.",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Pallete.blueColor,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(context, LoginView.route());
                                  },
                              )
                            ]),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
