import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/models/user_model.dart';
import 'package:sport_ticketing/pages/edit_profile_page.dart';
import 'package:sport_ticketing/pages/loading_page.dart';
import 'package:sport_ticketing/providers/auth_provider.dart';
import 'package:sport_ticketing/widgets/circular_avator.dart';

class UserProfileView extends ConsumerWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserModel? userModel = ref.watch(currentUserDetailsProvider).value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: userModel == null
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: CustomCircularAvator(
                          photoUrl: userModel.profilePic,
                          radius: 40,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Username: ${userModel.username}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Email: ${userModel.email}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
