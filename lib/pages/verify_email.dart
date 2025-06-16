import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/pages/loading_page.dart';
import 'package:sport_ticketing/providers/auth_provider.dart';

class VerifyEmail extends ConsumerStatefulWidget {
  const VerifyEmail({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends ConsumerState<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Verify Email'),
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _changeEmail(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.green,
                      ),
                    ),
                    child: const Text('Verify Email',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
    );
  }

  void _changeEmail(BuildContext context) {
    ref.read(authControllerProvider.notifier).verifyEmail(context);
  }
}
