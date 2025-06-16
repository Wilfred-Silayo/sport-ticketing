import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/apis/ticket_api.dart';
import 'package:sport_ticketing/models/ticket_model.dart';
import 'package:sport_ticketing/utils/utils.dart';

final userTicketControllerProvider =
    StateNotifierProvider<UserTicketController, bool>((ref) {
  return UserTicketController(ticketAPI: ref.watch(ticketAPIProvider));
});

final getUserTicketsProvider = StreamProvider.family((ref, String uid) {
  final userTicketController = ref.watch(userTicketControllerProvider.notifier);
  return userTicketController.getUserTickets(uid);
});

final getTicketProvider = StreamProvider.family(
  (ref, String id) =>
      ref.watch(userTicketControllerProvider.notifier).getTicket(id),
);

class UserTicketController extends StateNotifier<bool> {
  final TicketAPI _ticketAPI;
  UserTicketController({
    required TicketAPI ticketAPI,
  })  : _ticketAPI = ticketAPI,
        super(false);

  Stream<List<TicketModel>> getUserTickets(String uid) {
    return _ticketAPI.getUserTickets(uid);
  }

  Stream<TicketModel> getTicket(String id) {
    return _ticketAPI.getTicket(id);
  }

  void buyTicket({
    required String match,
    required double amount,
    required int seatNo,
    required String seatType,
    required String ticketNo,
    required String userId,
    required BuildContext context,
  }) async {
    state = true;
    final TicketModel ticket = TicketModel(
        ticketNo: ticketNo,
        match: match,
        timestamp: Timestamp.now().toDate(),
        amount: amount,
        seatType: seatType,
        seatNo: seatNo,
        isCancelled: false,
        uid: userId);
    final result = await checkTicketAvailability(ticketNo);
    if (result) {
      showSnackBar(context, "Oops! This seat is already sold.");
      return;
    }
    final res = await _ticketAPI.payTicket(ticket);
    state = false;
    res.fold((l) => showSnackBar(context, l.message),
        (r) => showSnackBar(context, 'Ticket Payed successfully!'));
  }

  void deleteTicket(TicketModel ticket, BuildContext context) async {
    state = true;
    final res = await _ticketAPI.deleteTicket(ticket);
    state = false;
    res.fold(
      (l) => null,
      (r) {
        showSnackBar(context, 'Ticket Deleted successfully!');
        return Navigator.pop(context);
      },
    );
  }

  void cancelTicket({
    required TicketModel ticket,
    required BuildContext context,
  }) async {
    state = true;

    TicketModel updatedTicket = ticket.copyWith();

    final res = await _ticketAPI.cancelTicket(updatedTicket);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => showSnackBar(context, 'Ticket Cancelled successfully!'),
    );
  }

  Future<bool> checkTicketAvailability(String id) async {
    return await _ticketAPI.checkTicketAvailability(id);
  }
}
