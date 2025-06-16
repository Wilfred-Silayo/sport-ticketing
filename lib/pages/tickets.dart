import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/models/match_model.dart';
import 'package:sport_ticketing/models/user_model.dart';
import 'package:sport_ticketing/pages/error_page.dart';
import 'package:sport_ticketing/pages/loading_page.dart';
import 'package:sport_ticketing/pages/ticket_history.dart';
import 'package:sport_ticketing/providers/match_provider.dart';
import 'package:sport_ticketing/providers/ticket_provider.dart';

class UserTicketsView extends ConsumerWidget {
  final UserModel userModel;

  const UserTicketsView({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  static Route<dynamic> route(UserModel userModel) {
    return MaterialPageRoute(
      builder: (context) => UserTicketsView(
        userModel: userModel,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text('Tickets history'),
        ),
        body: ref.watch(getUserTicketsProvider(userModel.uid)).when(
            data: (data) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final ticket = data[index];
                  final String dateTime =
                      'Created at Date:${ticket.timestamp.day}/${ticket.timestamp.month}/${ticket.timestamp.year} Time:${ticket.timestamp.hour}:${ticket.timestamp.minute < 10 ? '0${ticket.timestamp.minute}' : ticket.timestamp.minute}';
                  final MatchModel? matchModel =
                      ref.watch(getMatchProvider(ticket.match)).value;
                  return matchModel == null
                      ? const SizedBox()
                      : Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TicketHistory(
                                  user: userModel,
                                  match: matchModel,
                                  ticketId: ticket.ticketNo,
                                ),
                              ),
                            ),
                            title: Text(
                                "Match: ${matchModel.homeTeam} vs ${matchModel.awayTeam}"),
                            subtitle: Text(dateTime),
                            trailing: Text(ticket.seatType),
                          ),
                        );
                },
              );
            },
            error: (error, st) {
              // print(st);
              // print(error.toString());
              return ErrorPage(
                error: error.toString(),
              );
            },
            loading: () => const Loader()));
  }
}
