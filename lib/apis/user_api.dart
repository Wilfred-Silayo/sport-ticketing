import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sport_ticketing/models/user_model.dart';
import 'package:sport_ticketing/providers/firebase_providers.dart';
import 'package:sport_ticketing/utils/failure.dart';
import 'package:sport_ticketing/utils/type_defs.dart';

final userAPIProvider = Provider((ref) {
  return UserAPI(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
});

class UserAPI {
  final FirebaseFirestore _firestore;
  UserAPI({required FirebaseFirestore firestore}) : _firestore = firestore;

  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .set(userModel.toMap());
      return right(null);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureEitherVoid updateUserData(UserModel userModel) async{
    try {
      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .update(userModel.toMap());
      return right(null);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
}
