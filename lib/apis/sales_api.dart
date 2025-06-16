import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sport_ticketing/models/sales_model.dart';
import 'package:sport_ticketing/providers/firebase_providers.dart';
import 'package:sport_ticketing/utils/failure.dart';
import 'package:sport_ticketing/utils/type_defs.dart';

final salesAPIProvider = Provider(
  (ref) => SalesAPI(
    firestore: ref.watch(firebaseFirestoreProvider),
  ),
);

class SalesAPI {
  final FirebaseFirestore _firestore;
  SalesAPI({required FirebaseFirestore firestore}) : _firestore = firestore;

  FutureEitherVoid markSeatAsSold(Sales sale) async {
  try {
    final docSnapshot = await _firestore.collection('sales').doc(sale.id).get();
    if (docSnapshot.exists) {
      // Document exists, update it
      await _firestore.collection('sales').doc(sale.id).update({
        'seatNo': FieldValue.arrayUnion([sale.seatNo.first]),
        'ticketNo': FieldValue.arrayUnion(sale.ticketNo),
      });
    } else {
      // Document doesn't exist, create it
      await _firestore.collection('sales').doc(sale.id).set(sale.toMap());
    }
    return right(null);
  } catch (e, st) {
    return left(Failure(e.toString(), st));
  }
}


  FutureEitherVoid releaseSeat(Sales sale) async {
    try {
      await _firestore.collection('sales').doc(sale.id).update({
        'seatNo': FieldValue.arrayRemove(sale.seatNo),
        'ticketNo': FieldValue.arrayRemove(sale.ticketNo),
      });
      return right(null);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  Stream<List<int>> checkSeat(String id) {
    return _firestore.collection('sales').doc(id).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return [];
      }
      return List<int>.from(snapshot.data()!['seatNo'] ?? []);
    });
  }
}
