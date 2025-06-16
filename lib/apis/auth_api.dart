import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sport_ticketing/providers/firebase_providers.dart';
import 'package:sport_ticketing/utils/failure.dart';
import 'package:sport_ticketing/utils/type_defs.dart';

final authAPIProvider = Provider((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return AuthAPI(auth: auth);
});

class AuthAPI {
  final FirebaseAuth _auth;

  AuthAPI({required FirebaseAuth auth}) : _auth = auth;

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserCredential> register({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(credential);
    } on FirebaseAuthException catch (e, stackTrace) {
      print(e.message);
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  FutureEither<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(credential);
    } on FirebaseAuthException catch (e, stackTrace) {
      print(e.message);
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  FutureEitherVoid logout() async {
    try {
      await _auth.signOut();
      return right(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  FutureEitherVoid deleteAccount() async {
    try {
      final currentUser = _auth.currentUser;

      // Delete user posts
      await FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isEqualTo: currentUser!.uid)
          .get()
          .then((snapshot) {
        for (final doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      // Delete user's collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .delete();

      // Delete user account
      await currentUser.delete();

      return right(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? 'Some unexpected error occurred', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  FutureEitherVoid sendEmailVerification() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
      return right(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  FutureEitherVoid changePassword(String newPassword) async {
    try {
      await _auth.currentUser!.updatePassword(newPassword);
      return right(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  FutureEitherVoid changeEmail(String newEmail) async {
    try {
      await _auth.currentUser!.updateEmail(newEmail);
      return right(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }
}
