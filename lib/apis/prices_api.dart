import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/models/prices_model.dart';

final pricesAPIProvider = Provider((ref) {
  return PricesAPI(
    firestore: FirebaseFirestore.instance,
  );
});

class PricesAPI {
  final FirebaseFirestore _firestore;

  PricesAPI({required FirebaseFirestore firestore}) : _firestore = firestore;

  Stream<Prices> getPrices(String id) {
    return _firestore
        .collection('prices')
        .where('matchId', isEqualTo: id)
        .snapshots()
        .map(
          (event) => Prices.fromMap(event.docs.first.data()),
        );
  }
}
