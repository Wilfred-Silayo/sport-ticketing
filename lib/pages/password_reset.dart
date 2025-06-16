import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/utils/utils.dart';
import 'package:sport_ticketing/widgets/text_field.dart';

class PasswordReset extends ConsumerStatefulWidget {
  const PasswordReset({
    super.key,
  });

  @override
  ConsumerState<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends ConsumerState<PasswordReset> {
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  void resetPassword(String email, context) async {
    if (_emailController.text.isEmpty) {
      String res = 'Email can\'t be empty.';
      showSnackBar(context, res);
      return;
    }
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showSnackBar(
          context, 'Password reset email sent. Please check your inbox.');
      _emailController.text = '';
      Navigator.pop(context);
    } catch (error) {
      String errorMessage = 'Password reset failed. Please try again later.';
      if (error is FirebaseAuthException) {
        errorMessage = error.message.toString();
      }
      showSnackBar(context, errorMessage);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Reset'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            const Text(
              'Please enter your email to reset your password.',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16.0),
            FormInputField(
              textController: _emailController,
              hintText: 'Email',
              obscureText: false,
              prefixIcon: const Icon(
                Icons.keyboard,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => isLoading
                  ? null
                  : resetPassword(_emailController.text.trim(), context),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.green,
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
