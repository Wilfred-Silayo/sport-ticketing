import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/apis/sales_api.dart';
import 'package:sport_ticketing/models/sales_model.dart';
import 'package:sport_ticketing/models/stadium_model.dart';
import 'package:sport_ticketing/models/ticket_model.dart';
import 'package:sport_ticketing/utils/utils.dart';

final salesControllerProvider = StateNotifierProvider<SalesController, bool>(
  (ref) => SalesController(
    saleAPI: ref.watch(salesAPIProvider),
  ),
);

final checkSeatAvailabilityProvider =
    StreamProvider.autoDispose.family<List<int>, String>((ref, id) {
  final salesController = ref.watch(salesControllerProvider.notifier);
  return salesController.checkSeatAvailability(id: id);
});

class SalesController extends StateNotifier<bool> {
  final SalesAPI _saleAPI;
  SalesController({required SalesAPI saleAPI})
      : _saleAPI = saleAPI,
        super(false);

  void markAsSold({
    required BuildContext context,
    required String matchId,
    required String stadiumId,
    required String ticketNo,
    required String seatType,
    required int index,
    required int seatNo,
  }) async {
    final String id = '$stadiumId-$matchId-$seatType-A${index + 1}';
    final Sales sale = Sales(
        id: id,
        ticketNo: [ticketNo],
        seatNo: [seatNo],
        seatType: seatType,
        matchId: matchId,
        stadiumId: stadiumId);
    final res = await _saleAPI.markSeatAsSold(sale);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => null,
    );
  }

  void releaseSeat({
    required BuildContext context,
    required TicketModel ticket,
    required Stadium stadium,
  }) async {
    final String input = ticket.seatType;
    List<String> output = input.split(" ");
    final String id =
        '${stadium.id}-${ticket.match}-${output[0]}-${output[output.length - 1]}';
    final Sales sale = Sales(
        id: id,
        ticketNo: [ticket.ticketNo],
        seatNo: [ticket.seatNo],
        seatType: output[0],
        matchId: ticket.match,
        stadiumId: stadium.id);
    final res = await _saleAPI.releaseSeat(sale);
    res.fold(
      (l) {
      print(l.message);
      return showSnackBar(context, l.message);},
      (r) => null,
    );
  }

  Stream<List<int>> checkSeatAvailability({
    required String id,
  }) {
    return _saleAPI.checkSeat(id);
  }
}
