import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/pages/loading_page.dart';
import 'package:sport_ticketing/pages/password_reset.dart';
import 'package:sport_ticketing/pages/register_page.dart';
import 'package:sport_ticketing/providers/auth_provider.dart';
import 'package:sport_ticketing/widgets/button.dart';
import 'package:sport_ticketing/widgets/text_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() {
    ref.read(authControllerProvider.notifier).login(
          email: _emailController.text,
          password: _passwordController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      body: isLoading
          ? const Loader()
          : Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/login_pic.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        FormInputField(
                          textController: _emailController,
                          hintText: 'Email',
                          obscureText: false,
                          prefixIcon: const Icon(
                            Icons.keyboard,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        FormInputField(
                          textController: _passwordController,
                          hintText: 'Password',
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
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PasswordReset()),
                                    );
                                  });
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        MyButton(onTap: loginUser, text: 'Login'),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account?',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterPage(),
                                    ),
                                  );
                                });
                              },
                              child: const Text(
                                'Register now',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
