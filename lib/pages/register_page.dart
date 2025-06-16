import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/pages/loading_page.dart';
import 'package:sport_ticketing/pages/login_page.dart';
import 'package:sport_ticketing/providers/auth_provider.dart';
import 'package:sport_ticketing/widgets/button.dart';
import 'package:sport_ticketing/widgets/text_field.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmedPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _obscureText = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmedPasswordController.dispose();
    _usernameController.dispose();
  }

  void registerUser() {
    ref.read(authControllerProvider.notifier).register(
          email: _emailController.text,
          password: _passwordController.text,
          confirmedPassword: _confirmedPasswordController.text,
          username: _usernameController.text,
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
                      image: AssetImage('assets/register_pic.jpg'),
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
                          "Register",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        FormInputField(
                          textController: _usernameController,
                          hintText: 'Username',
                          obscureText: false,
                          prefixIcon: const Icon(
                            Icons.person,
                          ),
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
                          height: 30,
                        ),
                        FormInputField(
                          textController: _confirmedPasswordController,
                          hintText: 'Confirm Password',
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
                        MyButton(onTap: registerUser, text: 'Register'),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account?',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.blue),
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
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                });
                              },
                              child: const Text(
                                'Login now',
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
