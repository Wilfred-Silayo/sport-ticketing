import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/providers/auth_provider.dart';
import 'package:sport_ticketing/providers/user_provider.dart';
import 'package:sport_ticketing/utils/utils.dart';
import 'package:sport_ticketing/widgets/circular_avator.dart';
import 'package:sport_ticketing/widgets/text_field.dart';

import '../models/user_model.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  File? profileFile;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(
      text: ref.read(currentUserDetailsProvider).value?.username ?? '',
    );
    emailController = TextEditingController(
      text: ref.read(currentUserDetailsProvider).value?.email ?? '',
    );
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
  }

  void selectProfileImage() async {
    final profileImage = await pickImage();
    if (profileImage != null) {
      setState(() {
        profileFile = profileImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = ref.watch(currentUserDetailsProvider).value;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              ref
                  .read(userProfileControllerProvider.notifier)
                  .updateUserProfile(
                    userModel: user!.copyWith(
                      username: usernameController.text,
                      email: emailController.text,
                    ),
                    context: context,
                    profileFile: profileFile,
                  );
              ref.read(authControllerProvider.notifier).changeEmail(
                    context,
                    emailController.text,
                  );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                profileFile != null
                    ? CircleAvatar(
                        backgroundImage: FileImage(profileFile!),
                        radius: 40,
                      )
                    : CustomCircularAvator(
                        photoUrl: user!.profilePic, radius: 45),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: selectProfileImage,
                    child: const Icon(
                      Icons.add_photo_alternate,
                      color: Colors.green,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            FormInputField(
              textController: usernameController,
              hintText: 'Username',
              obscureText: false,
              prefixIcon: const Icon(
                Icons.person,
              ),
            ),
            const SizedBox(height: 30),
            FormInputField(
              textController: emailController,
              hintText: 'Email',
              obscureText: false,
              prefixIcon: const Icon(
                Icons.keyboard,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
