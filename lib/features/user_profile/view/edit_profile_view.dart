import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clonee/common/common.dart';
import 'package:twitter_clonee/core/utils.dart';
import 'package:twitter_clonee/features/auth/controller/auth_controller.dart';
import 'package:twitter_clonee/features/user_profile/controller/user_profile_controller.dart';

import 'package:twitter_clonee/theme/theme.dart';

class EditProfileView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const EditProfileView(),
      );
  const EditProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  File? bannerPic;
  File? profilePic;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(
        text: ref.read(currentUserDetailsProvider).value?.name ?? '');
    bioController = TextEditingController(
        text: ref.read(currentUserDetailsProvider).value?.bio ?? '');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    bioController.dispose();
  }

  void selectBannerPic() async {
    final banner = await pickImage();
    if (banner != null) {
      setState(() {
        bannerPic = banner;
      });
    }
  }

  void selectProfilePic() async {
    final profile = await pickImage();
    if (profile != null) {
      setState(() {
        profilePic = profile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(userProfileControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: false,
        actions: [
          RoundedSmallButton(
            onTap: () {
              ref.read(userProfileControllerProvider.notifier).updateUserData(
                    userModel: user!.copyWith(
                      name: nameController.text,
                      bio: bioController.text,
                    ),
                    context: context,
                    bannerFile: bannerPic,
                    profileFile: profilePic,
                  );
            },
            text: "Save",
            backgroundColor: Pallete.blueColor,
            textColor: Pallete.whiteColor,
          )
        ],
      ),
      body: isLoading || user == null
          ? const Loader()
          : Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: selectBannerPic,
                        child: SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: bannerPic != null
                              ? Image.file(
                                  bannerPic!,
                                  fit: BoxFit.fitWidth,
                                )
                              : user.bannerPic.isEmpty
                                  ? Container(
                                      color: Pallete.blueColor,
                                    )
                                  : Image.network(
                                      user.bannerPic,
                                      fit: BoxFit.fitWidth,
                                    ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: GestureDetector(
                          onTap: selectProfilePic,
                          child: profilePic != null
                              ? CircleAvatar(
                                  backgroundImage: FileImage(profilePic!),
                                  radius: 40,
                                )
                              : CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(user.profilePic),
                                  radius: 40,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: "Name",
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
                TextField(
                  controller: bioController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: "Bio",
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                )
              ],
            ),
    );
  }
}
