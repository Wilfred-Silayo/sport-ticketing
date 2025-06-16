import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/pages/verify_email.dart';
import 'package:sport_ticketing/providers/auth_provider.dart';
import 'package:sport_ticketing/widgets/dialog.dart';

import 'change_email.dart';
import 'change_password.dart';

class Security extends ConsumerWidget {
  const Security({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Security'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text(
              'Change password',
              style: TextStyle(fontSize: 16),
            ),
            subtitle: const Text(
              'Its is recommended to change your password regulary',
              style: TextStyle(fontSize: 14),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangePassword(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text(
              'Change email',
              style: TextStyle(fontSize: 16),
            ),
            subtitle: const Text(
              'You can change your email',
              style: TextStyle(fontSize: 14),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangeEmail(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.verified),
            title: const Text(
              'Verify your email',
              style: TextStyle(fontSize: 16),
            ),
            subtitle: const Text(
              'Its is recommended to verify your email, so that you can recover your account in case you forgot your password.',
              style: TextStyle(fontSize: 14),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VerifyEmail(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
            title: const Text(
              "Delete Account",
              style: TextStyle(fontSize: 16),
            ),
            subtitle: const Text(
              'Perfoming this action will erase all you information',
              style: TextStyle(fontSize: 14),
            ),
            onTap: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(
                    title: 'Delete Account',
                    content: 'Are you sure you want to delete your account?',
                    onConfirm: () {
                      ref
                          .read(authControllerProvider.notifier)
                          .deleteAccount(context);
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
