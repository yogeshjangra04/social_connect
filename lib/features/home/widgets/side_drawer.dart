import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clonee/common/common.dart';
import 'package:twitter_clonee/features/auth/controller/auth_controller.dart';
import 'package:twitter_clonee/features/user_profile/view/user_profile_view.dart';
import 'package:twitter_clonee/theme/pallete.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currUser = ref.watch(currentUserDetailsProvider).value;
    if (currUser == null) {
      return const Loader();
    }
    return SafeArea(
        child: Drawer(
      backgroundColor: Pallete.backgroundColor,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.person, size: 30),
            title: const Text(
              'My Profile',
              style: TextStyle(fontSize: 25),
            ),
            onTap: () {
              Navigator.push(context, UserProfileView.route(currUser));
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app_outlined, size: 30),
            title: const Text(
              'Log Out!Enough of This',
              style: TextStyle(fontSize: 25),
            ),
            onTap: () {
              ref.read(authControllerProvider.notifier).logout(context);
            },
          ),
        ],
      ),
    ));
  }
}
