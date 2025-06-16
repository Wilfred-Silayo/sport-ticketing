import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/models/user_model.dart';
import 'package:sport_ticketing/pages/loading_page.dart';
import 'package:sport_ticketing/providers/auth_provider.dart';
import 'package:sport_ticketing/providers/user_provider.dart';
import 'package:sport_ticketing/widgets/text_field.dart';

class ChangeEmail extends ConsumerStatefulWidget {
  const ChangeEmail({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends ConsumerState<ChangeEmail> {
  final _newEmailController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    final user = ref.watch(currentUserDetailsProvider).value;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Change Email'),
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FormInputField(
                    textController: _newEmailController,
                    hintText: 'Email',
                    obscureText: false,
                    prefixIcon: const Icon(
                      Icons.keyboard,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _changeEmail(context, user);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.green,
                        ),
                      ),
                      child: const Text('Change Email',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
    );
  }

  void _changeEmail(BuildContext context, UserModel? user) {
    final newEmail = _newEmailController.text;

    if (newEmail.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a new email.';
      });
      return;
    }
    ref.read(authControllerProvider.notifier).changeEmail(context, newEmail);

    ref.read(userProfileControllerProvider.notifier).updateUserProfile(
          userModel: user!.copyWith(
            email: _newEmailController.text,
          ),
          context: context,
          profileFile: null,
        );
    _newEmailController.text = '';
  }
}
