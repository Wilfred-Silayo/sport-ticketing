import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/models/match_model.dart';
import 'package:sport_ticketing/models/sales_model.dart';
import 'package:sport_ticketing/models/stadium_model.dart';
import 'package:sport_ticketing/pages/error_page.dart';
import 'package:sport_ticketing/pages/loading_page.dart';
import 'package:sport_ticketing/providers/sales_provider.dart';
import 'package:sport_ticketing/widgets/custom_row.dart';
import 'package:sport_ticketing/widgets/custom_seat.dart';

class SeatSelectionPage extends ConsumerStatefulWidget {
  final Stadium stadium;
  final String blockName;
  final int index;
  final String category;
  final MatchModel match;
  const SeatSelectionPage({
    super.key,
    required this.blockName,
    required this.category,
    required this.index,
    required this.stadium,
    required this.match,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SeatSelectionPageState();
}

class _SeatSelectionPageState extends ConsumerState<SeatSelectionPage> {
  @override
  Widget build(BuildContext context) {
    final String id =
        '${widget.stadium.id}-${widget.match.matchId}-${widget.category}-A${widget.index + 1}';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.blockName),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: CustomRow(
                  seats: widget.stadium.seatMap[widget.category]![widget.index]
                      as int),
            ),
          ),
          Expanded(
            child: ref.watch(checkSeatAvailabilityProvider(id)).when(
                  data: (List<int> data) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: widget.stadium
                          .seatMap[widget.category]![widget.index] as int,
                      itemBuilder: (context, seatIndex) {
                        final int seatNumber = seatIndex + 1;
                        final bool isSold = data.contains(seatNumber);
                        return CustomSeat(
                          isSold: isSold,
                          stadium: widget.stadium,
                          match: widget.match,
                          blockName: widget.blockName,
                          category: widget.category,
                          seatNumber: seatNumber,
                          index: widget.index,
                        );
                      },
                    );
                  },
                  error: (error, st) => ErrorPage(
                    error: error.toString(),
                  ),
                  loading: () => const Center(
                    child: Loader(),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
