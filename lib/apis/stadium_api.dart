import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/models/stadium_model.dart';

final stadiumAPIProvider = Provider((ref) {
  return StadiumAPI(
    firestore: FirebaseFirestore.instance,
  );
});

class StadiumAPI {
  final FirebaseFirestore _firestore;

  StadiumAPI({required FirebaseFirestore firestore}) : _firestore = firestore;

  Stream<Stadium> getStadiums(String id) {
    return _firestore
        .collection('stadiums')
        .where('id', isEqualTo: id)
        .snapshots()
        .map(
          (event) => Stadium.fromMap(event.docs.first.data()),
        );
  }
}
