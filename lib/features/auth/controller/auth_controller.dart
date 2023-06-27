import 'package:appwrite/models.dart' as model;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clonee/apis/auth_api.dart';
// import 'package:twitter_clone/apis/user_api.dart';
// import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clonee/features/auth/view/login_view.dart';
import 'package:twitter_clonee/features/auth/view/signup_view.dart';
import 'package:twitter_clonee/core/core.dart';
import 'package:twitter_clonee/features/home/view/home_view.dart';
import 'package:twitter_clonee/features/user_profile/controller/user_profile_controller.dart';

import '../../../apis/user_api.dart';
import '../../../models/user_model.dart';
// import 'package:twitter_clone/features/home/view/home_view.dart';
// import 'package:twitter_clone/models/user_model.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  );
});

final currentUserDetailsProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(currentUserAccountProvider).when(
        data: (data) {
          if (data != null) {
            final currentUserId = data.$id;
            final userDetails = ref.watch(
              userDetailsProvider(currentUserId),
            );
            return userDetails.value;
          } else {
            ref.invalidate(currentUserAccountProvider);
          }
          return null;
        },
        error: (error, st) => null,
        loading: () => null,
      );
});

final userDetailsProvider =
    FutureProvider.autoDispose.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  ref.watch(getLatestUserProfileDataProvider(uid));
  return authController.getUserData(uid);
});

final currentUserAccountProvider = FutureProvider.autoDispose((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  final res = authController.currentUser();
  res.asStream().listen((account) {
    debugPrint('LoggedInAccount:-  ${account!.$id}');
  });
  return res;
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({
    required AuthAPI authAPI,
    required UserAPI userAPI,
  })  : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);
//   // state = isLoading

  Future<model.Account?> currentUser() => _authAPI.currentUserAccount();

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password,
    );
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      UserModel userModel = UserModel(
        email: email,
        name: getNameFromEmail(email),
        followers: const [],
        following: const [],
        profilePic: '',
        bannerPic: '',
        uid: r.$id,
        bio: '',
        isTwitterBlue: false,
      );
      final res2 = await _userAPI.saveUserData(userModel);
      res2.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Accounted created! Please login.');
        Navigator.push(context, LoginView.route());
      });
    });
//async {
//         UserModel userModel = UserModel(
//           email: email,
//           name: getNameFromEmail(email),
//           followers: const [],
//           following: const [],
//           profilePic: '',
//           bannerPic: '',
//           uid: r.$id,
//           bio: '',
//           isTwitterBlue: false,
//         );
//         final res2 = await _userAPI.saveUserData(userModel);
//         res2.fold((l) => showSnackBar(context, l.message), (r) {
//           showSnackBar(context, 'Accounted created! Please login.');
//           Navigator.push(context, LoginView.route());
//         });
//       },
//     );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        Navigator.push(context, HomeView.route());
        // Navigator.push(context, HomeView.route());
      },
    );
  }

  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    final updatedUser = UserModel.fromMap(document.data);
    return updatedUser;
  }

  void logout(BuildContext context) async {
    final res = await _authAPI.logout();
    res.fold((l) => null, (r) {
      Navigator.pushAndRemoveUntil(
        context,
        SignUpView.route(),
        (route) => false,
      );
    });
  }
}
