import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clonee/common/loading_page.dart';
import 'package:twitter_clonee/constants/ui_constants.dart';
import 'package:twitter_clonee/features/auth/view/signup_view.dart';

import '../../../common/rounded_small_button.dart';
import '../../../theme/theme.dart';
import '../controller/auth_controller.dart';
import '../widgets/auth_field.dart';

class LoginView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginView(),
      );
  const LoginView({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
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

  void onLogin() {
    ref.read(authControllerProvider.notifier).login(
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
                        child: RoundedSmallButton(onTap: onLogin, text: "Done"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      RichText(
                        text: TextSpan(
                            text: "New user?",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Pallete.whiteColor,
                            ),
                            children: [
                              TextSpan(
                                text: "  SignUp.",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Pallete.blueColor,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(context, SignUpView.route());
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
