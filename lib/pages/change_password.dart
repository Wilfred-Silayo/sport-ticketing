import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/pages/loading_page.dart';
import 'package:sport_ticketing/widgets/text_field.dart';

import '../providers/auth_provider.dart';

class ChangePassword extends ConsumerStatefulWidget {
  const ChangePassword({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends ConsumerState<ChangePassword> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _errorMessage = '';
  bool _obscureText = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Change Password'),
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FormInputField(
                    textController: _currentPasswordController,
                    hintText: 'Current Password',
                    obscureText: !_obscureText,
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    suffixIcon: _obscureText
                        ? const Icon(
                            Icons.visibility_off,
                            color: Colors.black,
                          )
                        : const Icon(
                            Icons.visibility,
                            color: Colors.black,
                          ),
                    onSuffixIconTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  FormInputField(
                    textController: _newPasswordController,
                    hintText: 'New Password',
                    obscureText: !_obscureText,
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    suffixIcon: _obscureText
                        ? const Icon(
                            Icons.visibility_off,
                            color: Colors.black,
                          )
                        : const Icon(
                            Icons.visibility,
                            color: Colors.black,
                          ),
                    onSuffixIconTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  FormInputField(
                    textController: _confirmPasswordController,
                    hintText: 'Confirm New Password',
                    obscureText: !_obscureText,
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    suffixIcon: _obscureText
                        ? const Icon(
                            Icons.visibility_off,
                            color: Colors.black,
                          )
                        : const Icon(
                            Icons.visibility,
                            color: Colors.black,
                          ),
                    onSuffixIconTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _updatePassword(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.green,
                      ),
                    ),
                    child: const Text('Update Password',
                        style: TextStyle(color: Colors.white)),
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

  void _updatePassword(BuildContext context) {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields.';
      });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        _errorMessage = 'Passwords do not match.';
      });
      return;
    }
    ref
        .read(authControllerProvider.notifier)
        .changePassword(context, newPassword);
    _currentPasswordController.text = '';
    _newPasswordController.text = '';
    _confirmPasswordController.text = '';
  }
}
