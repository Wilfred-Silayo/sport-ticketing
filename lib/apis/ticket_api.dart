import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sport_ticketing/models/ticket_model.dart';
import 'package:sport_ticketing/utils/failure.dart';
import 'package:sport_ticketing/utils/type_defs.dart';

final ticketAPIProvider = Provider((ref) {
  return TicketAPI(
    firestore: FirebaseFirestore.instance,
  );
});

class TicketAPI {
  final FirebaseFirestore _firestore;

  TicketAPI({required FirebaseFirestore firestore}) : _firestore = firestore;

  FutureEitherVoid payTicket(TicketModel ticket) async {
    try {
      await _firestore
          .collection('tickets')
          .doc(ticket.ticketNo)
          .set(ticket.toMap());
      return right(null);
    } on FirebaseException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  FutureEitherVoid deleteTicket(TicketModel ticket) async {
    try {
      await _firestore.collection('tickets').doc(ticket.ticketNo).delete();
      return right(null);
    } on FirebaseException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  FutureEitherVoid cancelTicket(TicketModel ticket) async {
    try {
      await _firestore
          .collection('tickets')
          .doc(ticket.ticketNo)
          .update(ticket.toMap());
      return right(null);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  Future<bool> checkTicketAvailability(String id) async {
    final snapshot = await _firestore.collection('tickets').doc(id).get();
    return snapshot.exists;
  }

  Stream<List<TicketModel>> getUserTickets(String uid) {
    return _firestore
        .collection('tickets')
        .where('uid', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => TicketModel.fromMap(
                  e.data(),
                ),
              )
              .toList(),
        );
  }

  Stream<TicketModel> getTicket(String id) {
    return _firestore
        .collection('tickets')
        .where('ticketNo', isEqualTo: id)
        .snapshots()
        .map(
          (event) => TicketModel.fromMap(event.docs.first.data()),
        );
  }
}
