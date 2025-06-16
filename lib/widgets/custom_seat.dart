import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/models/match_model.dart';
import 'package:sport_ticketing/models/stadium_model.dart';
import 'package:sport_ticketing/pages/ticket_preview.dart';
import 'package:sport_ticketing/utils/utils.dart';

class CustomSeat extends ConsumerStatefulWidget {
  final Stadium stadium;
  final String blockName;
  final String category;
  final MatchModel match;
  final int seatNumber;
  final int index;
  final bool isSold;
  const CustomSeat({
    super.key,
    required this.seatNumber,
    required this.isSold,
    required this.index,
    required this.blockName,
    required this.stadium,
    required this.category,
    required this.match,
  });

  @override
  ConsumerState<CustomSeat> createState() => _CustomSeatState();
}

class _CustomSeatState extends ConsumerState<CustomSeat> {
  @override
  Widget build(BuildContext context) {
    return
     InkWell(
      onTap: () {
        widget.isSold
            ? showSnackBar(context, "Oops! The seat is sold")
            : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicketPreview(
                    seatNumber: widget.seatNumber,
                    blockName: widget.blockName,
                    stadium: widget.stadium,
                    category: widget.category,
                    match: widget.match,
                    index: widget.index,
                  ),
                ),
              );
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.isSold ? Colors.red : Colors.green,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            '${widget.seatNumber}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
