import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/models/match_model.dart';
import 'package:sport_ticketing/models/stadium_model.dart';
import 'package:sport_ticketing/pages/seat_selection.dart';

class TicketCategory extends ConsumerStatefulWidget {
  final MatchModel match;
  final Stadium stadium;
  const TicketCategory({super.key, required this.match, required this.stadium});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TicketCategoryState();
}

class _TicketCategoryState extends ConsumerState<TicketCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildFootballGround(),
            _buildStadiumBlocks(),
          ],
        ),
      ),
    );
  }

  Widget _buildFootballGround() {
    return Container(
      width: 300,
      height: 500,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/football_ground.jpg'), // Replace with your image asset path
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildStadiumBlocks() {
    return Stack(
      children: [
        // Top Block (ROUND) with increased margin
        Positioned(
          top: 20, // Adjust this value to increase the margin from the top
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildMajorBlock('ROUND', Colors.purple, isVertical: false),
          ),
        ),
        // Bottom Block (ORANGE) with increased margin
        Positioned(
          bottom: 20, // Adjust this value to increase the margin from the bottom
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildMajorBlock('ORANGE', Colors.blue, isVertical: false),
          ),
        ),
        // Left Blocks (VVIP and VIPA)
        Positioned(
          top: 80,
          left: 0,
          bottom: 80,
          child: SizedBox(
            width: 100,
            child: _buildMajorBlock('VVIP', Colors.red, isVertical: true),
          ),
        ),
        Positioned(
          top: 80,
          left: 0,
          bottom: 80,
          child: SizedBox(
            width: 100,
            child: _buildMajorBlock('VIPA', Colors.orange, isVertical: true),
          ),
        ),
        // Right Blocks (VIPB and VIPC)
        Positioned(
          top: 80,
          right: 0,
          bottom: 80,
          child: SizedBox(
            width: 100,
            child: _buildMajorBlock('VIPB', Colors.yellow, isVertical: true),
          ),
        ),
        Positioned(
          top: 80,
          right: 0,
          bottom: 80,
          child: SizedBox(
            width: 100,
            child: _buildMajorBlock('VIPC', Colors.green, isVertical: true),
          ),
        ),
      ],
    );
  }

  Widget _buildMajorBlock(String category, Color color, {required bool isVertical}) {
    return Container(
      margin: EdgeInsets.all(8.0),
      width: isVertical ? 100 : double.infinity,
      height: isVertical ? double.infinity : 80,
      color: color.withOpacity(0.3),
      child: isVertical
          ? Column(
              children: List.generate(4, (index) => _buildMinorBlock(category, color, index)),
            )
          : Row(
              children: List.generate(4, (index) => _buildMinorBlock(category, color, index)),
            ),
    );
  }

  Widget _buildMinorBlock(String category, Color color, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _navigateToSeatSelection(category, index + 1),
        child: Container(
          margin: EdgeInsets.all(4.0),
          color: color,
          child: Center(
            child: Text(
              '$category Block ${index + 1}',
              style: TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToSeatSelection(String category, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeatSelectionPage(
          blockName: '$category Block $index',
          stadium: widget.stadium,
          index: index,
          category: category,
          match: widget.match,
        ),
      ),
    );
  }
}
