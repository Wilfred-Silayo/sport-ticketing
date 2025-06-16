import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sport_ticketing/models/match_model.dart';
import 'package:sport_ticketing/models/stadium_model.dart';
import 'package:sport_ticketing/models/user_model.dart';

Future<Uint8List> makePdf({
  required MatchModel match,
  required Stadium stadium,
  required int seatNo,
  required String seatType,
  required String ticketno,
  required UserModel user,
  required double amount,
}) async {
  final pdf = Document();
  final imageLogo = MemoryImage(
      (await rootBundle.load('assets/launcher_icon.png')).buffer.asUint8List());
  pdf.addPage(
    Page(
      build: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text("Attention to: ${stadium.name}"),
                    Text("official Receipt"),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image(imageLogo),
                )
              ],
            ),
            Container(height: 50),
            PaddedText(
              'RECEIPT FOR TICKET PAYMENT',
              align: TextAlign.center,
            ),
            ..._buildItems(
                match, stadium, seatNo, seatType, ticketno, user, amount),
            PaddedText(
              "THANK YOU FOR YOUR CUSTOM!",
              align: TextAlign.center,
            ),
            Divider(height: 1, thickness: 1, color: PdfColors.black),
          ],
        );
      },
    ),
  );
  return pdf.save();
}

List<Widget> _buildItems(
  MatchModel match,
  Stadium stadium,
  int seatNo,
  String seatType,
  String ticketno,
  UserModel user,
  double amount,
) {
  double tax = amount / 10;
  String matchToPlay = "${match.homeTeam} vs ${match.awayTeam}";
  return [
    _buildListItem("Match Name", matchToPlay),
    _buildListItem("Stadium", stadium.name),
    _buildListItem("Seat Number", seatNo.toString()),
    _buildListItem("Seat Type", seatType),
    _buildListItem("Ticket Number", ticketno),
    _buildListItem("User Name", user.username),
    _buildListItem("User Email", user.email),
    _buildListItem("Amount", 'Tzs $amount'),
    _buildListItem("Tax", 'Tzs $tax'),
  ];
}

Widget _buildListItem(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      Text(value),
      SizedBox(height: 10),
      Divider(height: 1, thickness: 0.5, color: PdfColors.grey),
      SizedBox(height: 10),
    ],
  );
}

Widget PaddedText(
  final String text, {
  final TextAlign align = TextAlign.left,
}) =>
    Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: align,
      ),
    );
