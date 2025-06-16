import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sport_ticketing/models/match_model.dart';
import 'package:sport_ticketing/models/stadium_model.dart';
import 'package:sport_ticketing/models/ticket_model.dart';
import 'package:sport_ticketing/models/user_model.dart';
import 'package:sport_ticketing/pages/error_page.dart';
import 'package:sport_ticketing/pages/loading_page.dart';
import 'package:sport_ticketing/pages/next_match.dart';
import 'package:sport_ticketing/providers/sales_provider.dart';
import 'package:sport_ticketing/providers/stadium_provider.dart';
import 'package:sport_ticketing/providers/ticket_provider.dart';

class TicketHistory extends ConsumerWidget {
  final UserModel user;
  final MatchModel match;
  final String ticketId;
  const TicketHistory({
    super.key,
    required this.match,
    required this.ticketId,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Ticket Preview"),
      ),
      body: ref.watch(getTicketProvider(ticketId)).when(
            data: (ticket) {
              final bool isLoading = ref.watch(userTicketControllerProvider);
              final Stadium? stadium =
                  ref.watch(getStadiumProvider(match.stadiumId)).value;
              final String matchToPlay =
                  "${match.homeTeam} vs ${match.awayTeam}";
              final double totalPrice = ticket.amount;
              final formattedPrice =
                  NumberFormat("#,##0.00", "en_US").format(totalPrice);
              final formattedTax =
                  NumberFormat("#,##0.00", "en_US").format(totalPrice / 10);
              return stadium == null || isLoading
                  ? const Loader()
                  : ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Customer',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        user.username,
                                        style: const TextStyle(fontSize: 16),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        user.email,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Card(
                            child: Column(
                              children: [
                                const SizedBox(height: 3),
                                const Text(
                                  'Ticket Items',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 3),
                                const Divider(),
                                ListTile(
                                  title: const Text("TicketNo:"),
                                  trailing: Text(
                                    ticket.ticketNo,
                                  ),
                                ),
                                ListTile(
                                  title: const Text("Match:"),
                                  trailing: Text(
                                    matchToPlay,
                                  ),
                                ),
                                ListTile(
                                  title: const Text("Date of Play:"),
                                  trailing: Text(
                                    "${match.timestamp.day}/${match.timestamp.month}/${match.timestamp.year}",
                                  ),
                                ),
                                ListTile(
                                  title: const Text("Time of Play:"),
                                  trailing: Text(
                                    'Time: ${match.timestamp.hour}:${match.timestamp.minute < 10 ? '0${match.timestamp.minute}' : match.timestamp.minute}',
                                  ),
                                ),
                                ListTile(
                                  title: const Text("Stadium:"),
                                  trailing: Text(
                                    stadium.name,
                                  ),
                                ),
                                ListTile(
                                  title: const Text("Seat Type:"),
                                  trailing: Text(
                                    ticket.seatType,
                                  ),
                                ),
                                ListTile(
                                  title: const Text("Seat No:"),
                                  trailing: Text(
                                    ticket.seatNo.toString(),
                                  ),
                                ),
                                const Divider(),
                                DefaultTextStyle.merge(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Text("Total Amount"),
                                          Text(
                                            formattedPrice,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Text("Total Tax"),
                                          Text(
                                            formattedTax,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Card(
                            color: ticket.isCancelled ||
                                    match.timestamp.isBefore(DateTime.now())
                                ? Colors.red
                                : Colors.grey[100],
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                if (!ticket.isCancelled &&
                                    match.timestamp.isAfter(DateTime.now())) {
                                  ref
                                      .read(
                                          userTicketControllerProvider.notifier)
                                      .cancelTicket(
                                        ticket:
                                            ticket.copyWith(isCancelled: true),
                                        context: context,
                                      );
                                  ref
                                      .read(salesControllerProvider.notifier)
                                      .releaseSeat(
                                          context: context,
                                          ticket: ticket,
                                          stadium: stadium);
                                } else if (ticket.isCancelled ||
                                    match.timestamp.isBefore(DateTime.now())) {
                                  ref
                                      .read(
                                          userTicketControllerProvider.notifier)
                                      .deleteTicket(ticket, context);
                                }
                              },
                              child: SizedBox(
                                width: double
                                    .infinity, // Make the button as wide as the parent
                                child: Center(
                                  child: Text(
                                    ticket.isCancelled ||
                                            match.timestamp
                                                .isBefore(DateTime.now())
                                        ? "Delete"
                                        : "Cancel",
                                    style: TextStyle(
                                      color: ticket.isCancelled ||
                                              match.timestamp
                                                  .isBefore(DateTime.now())
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ticket.isCancelled
                            ? Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NextMatch(matchModel: match),
                                      ),
                                    );
                                  },
                                  child: const Card(
                                    color: Colors.green,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15.0),
                                      child: Center(
                                        child: Text(
                                          "Rebook the ticket for the next match",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    );
            },
            error: (error, st) {
              // print(st);
              // print(error.toString());
              return ErrorPage(
                error: error.toString(),
              );
            },
            loading: () => const SizedBox(),
          ),
    );
  }
}
