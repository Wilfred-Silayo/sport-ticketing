import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/models/match_model.dart';
import 'package:sport_ticketing/models/stadium_model.dart';
import 'package:sport_ticketing/pages/ticket_category.dart';
import 'package:sport_ticketing/providers/stadium_provider.dart';

class MatchCard extends ConsumerWidget {
  final MatchModel match;

  const MatchCard({Key? key, required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Stadium? stadium =
        ref.watch(getStadiumProvider(match.stadiumId)).value;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TicketCategory(match: match, stadium: stadium!),
          ),
        );
      },
      child: stadium == null
          ? const SizedBox()
          : Card(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${match.homeTeam} vs ${match.awayTeam}',
                      style: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                        'Date: ${match.timestamp.day}/${match.timestamp.month}/${match.timestamp.year}'),
                    Text(
                      'Time: ${match.timestamp.hour}:${match.timestamp.minute < 10 ? '0${match.timestamp.minute}' : match.timestamp.minute}',
                    ),
                    Text('Stadium: ${stadium.name}'),
                    const SizedBox(height: 16.0),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TicketCategory(match: match, stadium: stadium),
                          ),
                        );
                      },
                      child: const Text('Buy Ticket'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
