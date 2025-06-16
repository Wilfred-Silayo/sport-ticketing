import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:sport_ticketing/models/match_model.dart';
import 'package:sport_ticketing/models/stadium_model.dart';
import 'package:sport_ticketing/models/user_model.dart';
import 'package:sport_ticketing/pages/home_page.dart';
import 'package:sport_ticketing/providers/pdf_provider.dart';

class PdfPreviewPage extends StatelessWidget {
  final String ticketNo;
  final MatchModel match;
  final Stadium stadium;
  final UserModel user;
  final double amount;
  final String seatType;
  final int seatNo;
  const PdfPreviewPage(
      {Key? key,
      required this.ticketNo,
      required this.match,
      required this.user,
      required this.amount,
      required this.seatNo,
      required this.seatType,
      required this.stadium})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
            (route) => false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text('PDF Preview'),
        ),
        body: PdfPreview(
          build: (context) => makePdf(
              ticketno: ticketNo,
              match: match,
              user: user,
              amount: amount,
              seatNo: seatNo,
              seatType: seatType,
              stadium: stadium),
        ),
      ),
    );
  }
}
