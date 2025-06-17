import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sport_ticketing/models/account_model.dart';

class AccountAPI {
  final FirebaseFirestore firestore;

  AccountAPI(this.firestore);

  Future<AccountModel?> getAccount(String userId) async {
    final query = await firestore
        .collection('accounts')
        .where('user_id', isEqualTo: userId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    return AccountModel.fromMap(query.docs.first.data());
  }

  Stream<AccountModel?> streamAccount(String userId) {
    return firestore
        .collection('accounts')
        .where('user_id', isEqualTo: userId)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return AccountModel.fromMap(snapshot.docs.first.data());
        });
  }

  Future<AccountModel> deposit(String userId, double amount) async {
    final existing = await getAccount(userId);

    if (existing != null) {
      final docId = await _getAccountDocId(userId);
      await firestore.collection('accounts').doc(docId).update({
        'balance': existing.balance + amount,
      });

      final updatedDoc = await firestore
          .collection('accounts')
          .doc(docId)
          .get();
      return AccountModel.fromMap(updatedDoc.data()!);
    } else {
      final doc = await firestore.collection('accounts').add({
        'user_id': userId,
        'balance': amount,
      });

      final insertedDoc = await doc.get();
      return AccountModel.fromMap(insertedDoc.data()!);
    }
  }

  Future<AccountModel> withdraw(String userId, double amount) async {
    final existing = await getAccount(userId);

    if (existing == null || existing.balance < amount) {
      throw Exception('Insufficient balance.');
    }

    final docId = await _getAccountDocId(userId);

    await firestore.collection('accounts').doc(docId).update({
      'balance': existing.balance - amount,
    });

    final updatedDoc = await firestore.collection('accounts').doc(docId).get();
    return AccountModel.fromMap(updatedDoc.data()!);
  }

  Future<String> _getAccountDocId(String userId) async {
    final query = await firestore
        .collection('accounts')
        .where('user_id', isEqualTo: userId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      throw Exception("Account not found for user_id: $userId");
    }

    return query.docs.first.id;
  }
}
