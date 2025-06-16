import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/apis/auth_api.dart';
import 'package:sport_ticketing/apis/user_api.dart';
import 'package:sport_ticketing/models/user_model.dart';
import 'package:sport_ticketing/pages/home_page.dart';
import 'package:sport_ticketing/pages/login_page.dart';
import 'package:sport_ticketing/utils/utils.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  );
});

final currentUserDetailsProvider = StreamProvider((ref) {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.uid;
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(currentUserId);
});

final currentUserAccountProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({
    required AuthAPI authAPI,
    required UserAPI userAPI,
  })  : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);
  // state = isLoading

  Stream<User?> get authStateChange => _authAPI.authStateChange;

  void register({
    required String email,
    required String password,
    required String confirmedPassword,
    required String username,
    required BuildContext context,
  }) async {
    state = true;
    if (password != confirmedPassword) {
      showSnackBar(context, "Confirmed password does not match with password!");
      return;
    }
    final res = await _authAPI.register(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        state = true;
        UserModel userModel = UserModel(
          email: email,
          username: username,
          profilePic: '',
          uid: r.user!.uid,
        );
        final res2 = await _userAPI.saveUserData(userModel);
        state = false;
        res2.fold((l) => showSnackBar(context, l.message), (r) {
          showSnackBar(context, 'Accounted created successfuly!');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false);
        });
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    });
  }

  Stream<UserModel> getUserData(String uid) {
    return _userAPI.getUserData(uid);
  }

  void logout(BuildContext context) async {
    state = true;
    final res = await _authAPI.logout();
    state = false;
    res.fold((l) => null, (r) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    });
  }

  void deleteAccount(BuildContext context) async {
    state = true;
    final res = await _authAPI.deleteAccount();
    state = false;
    res.fold((l) => null, (r) {
      showSnackBar(context, 'Account Deleted successfully');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    });
  }

  void changePassword(BuildContext context, String password) async {
    final res = await _authAPI.changePassword(password);
    res.fold((l) => null, (r) {
      showSnackBar(context, 'Password changed successfully');
    });
  }

  void verifyEmail(
    BuildContext context,
  ) async {
    state = true;
    final res = await _authAPI.sendEmailVerification();
    state = false;
    res.fold((l) => null, (r) {
      showSnackBar(context,
          'Verification email sent successfully. Please check your inbox');
    });
  }

  void changeEmail(BuildContext context, String newEmail) async {
    final res = await _authAPI.changeEmail(newEmail);
    res.fold((l) => null, (r) {
      showSnackBar(context, 'Email changed successfully');
    });
  }
}
