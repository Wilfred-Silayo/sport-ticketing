import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/models/match_model.dart';
import 'package:sport_ticketing/providers/firebase_providers.dart';
import 'package:rxdart/rxdart.dart';

final matchAPIProvider = Provider((ref) {
  return MatchAPI(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
});

class MatchAPI {
  final FirebaseFirestore _firestore;

  MatchAPI({required FirebaseFirestore firestore}) : _firestore = firestore;

  Stream<List<MatchModel>> getMatches() {
    return _firestore
        .collection('matches')
        .where('timestamp', isGreaterThan: Timestamp.now())
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (event) => event.docs.isEmpty
              ? [] // Return empty list if no documents found
              : event.docs
                  .map(
                    (e) => MatchModel.fromMap(
                      e.data(),
                    ),
                  )
                  .toList(),
        );
  }


   Stream<List<MatchModel>> getNextMatches(MatchModel match) {
     return _firestore
      .collection('matches')
      .where('timestamp', isGreaterThan: Timestamp.now())
      .orderBy('timestamp', descending: false)
      .snapshots()
      .map(
        (event) => event.docs.isEmpty
            ? [] // Return empty list if no documents found
            : event.docs
                .map(
                  (e) => MatchModel.fromMap(
                    e.data(),
                  ),
                )
                .where((snap) =>
                    snap.homeTeam == match.homeTeam || snap.awayTeam == match.awayTeam)
                .toList(),
      );
  }

  Future<MatchModel> getMatch(String id) async {
    final snapshot = await _firestore.collection("matches").doc(id).get();
    return MatchModel.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  Stream<List<MatchModel>> searchMatch(String query) {
    String lowercaseQuery = query.toLowerCase();
    String capitalizedQuery = lowercaseQuery.isEmpty
        ? ''
        : '${lowercaseQuery.substring(0, 1).toUpperCase()}${lowercaseQuery.substring(1)}';

    // Query for matches where homeTeam matches the query
    var homeTeamQuery = _firestore
        .collection('matches')
        .where('homeTeam', isGreaterThanOrEqualTo: capitalizedQuery)
        .where('homeTeam', isLessThan: '${capitalizedQuery}z')
        .snapshots();

    // Query for matches where awayTeam matches the query
    var awayTeamQuery = _firestore
        .collection('matches')
        .where('awayTeam', isGreaterThanOrEqualTo: capitalizedQuery)
        .where('awayTeam', isLessThan: '${capitalizedQuery}z')
        .snapshots();

    // Combine the results of both queries
    return CombineLatestStream(
      [homeTeamQuery, awayTeamQuery],
      (List<QuerySnapshot> snapshots) {
        var homeTeamDocs = snapshots[0]
            .docs
            .map(
                (doc) => MatchModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
        var awayTeamDocs = snapshots[1]
            .docs
            .map(
                (doc) => MatchModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
        return [...homeTeamDocs, ...awayTeamDocs];
      },
    );
  }
}
