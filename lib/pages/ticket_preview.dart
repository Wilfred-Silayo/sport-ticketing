import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sport_ticketing/models/user_model.dart';
import 'package:sport_ticketing/pages/error_page.dart';
import 'package:sport_ticketing/pages/loading_page.dart';
import 'package:sport_ticketing/pages/pdf_preview.dart';
import 'package:sport_ticketing/providers/account_provider.dart';
import 'package:sport_ticketing/providers/auth_provider.dart';
import 'package:sport_ticketing/providers/price_provider.dart';
import 'package:sport_ticketing/providers/sales_provider.dart';
import 'package:sport_ticketing/providers/ticket_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/match_model.dart';
import '../models/stadium_model.dart';

class TicketPreview extends ConsumerStatefulWidget {
  const TicketPreview({
    Key? key,
    required this.blockName,
    required this.index,
    required this.stadium,
    required this.category,
    required this.seatNumber,
    required this.match,
  }) : super(key: key);

  final int seatNumber;
  final int index;
  final Stadium stadium;
  final String blockName;
  final String category;
  final MatchModel match;

  @override
  ConsumerState<TicketPreview> createState() => _TicketPreviewState();
}

class _TicketPreviewState extends ConsumerState<TicketPreview> {
  bool isPaid = false;

  @override
  Widget build(BuildContext context) {
    final String ticketNo = const Uuid().v1();
    final String matchToPlay = "${widget.match.homeTeam} vs ${widget.match.awayTeam}";
    final UserModel? user = ref.watch(currentUserDetailsProvider).value;
    final bool isLoading = ref.watch(userTicketControllerProvider);
    final bool isLoadingSale = ref.watch(salesControllerProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final currentUserAccount = await ref.read(accountProvider.notifier).getAccountById(user!.uid);

          ref.read(getpricesProvider(widget.match.matchId)).when(
            data: (prices) {
              double totalPrice;
              switch (widget.category) {
                case 'VVIP':
                  totalPrice = prices.VVIP;
                  break;
                case 'VIPA':
                  totalPrice = prices.VIPA;
                  break;
                case 'VIPB':
                  totalPrice = prices.VIPB;
                  break;
                case 'VIPC':
                  totalPrice = prices.VIPC;
                  break;
                case 'ROUND':
                  totalPrice = prices.ROUND;
                  break;
                case 'ORANGE':
                  totalPrice = prices.ORANGE;
                  break;
                default:
                  totalPrice = 0.0;
              }

              if (currentUserAccount.balance >= totalPrice) {
                // Withdraw money
                ref.read(accountProvider.notifier).withdraw(user.uid, totalPrice);

                // Book ticket
                ref.read(userTicketControllerProvider.notifier).buyTicket(
                  match: widget.match.matchId,
                  amount: totalPrice,
                  seatNo: widget.seatNumber,
                  seatType: widget.blockName,
                  ticketNo: ticketNo,
                  userId: user.uid,
                  context: context,
                );

                // Mark seat as sold
                ref.read(salesControllerProvider.notifier).markAsSold(
                  index: widget.index,
                  context: context,
                  matchId: widget.match.matchId,
                  stadiumId: widget.stadium.id,
                  ticketNo: ticketNo,
                  seatType: widget.category,
                  seatNo: widget.seatNumber,
                );

                setState(() {
                  isPaid = true;
                });

                // Navigate to PDF Preview
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfPreviewPage(
                      match: widget.match,
                      amount: totalPrice,
                      seatNo: widget.seatNumber,
                      seatType: widget.blockName,
                      ticketNo: ticketNo,
                      stadium: widget.stadium,
                      user: user,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Insufficient balance: Tsh ${currentUserAccount.balance.toStringAsFixed(2)}',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            error: (error, st) => print("Error loading prices: $error"),
            loading: () => print("Loading prices..."),
          );
        },
        child: const Icon(Icons.payment),
      ),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Ticket Preview"),
      ),
      body: user == null || isLoading || isLoadingSale
          ? const Loader()
          : ref.watch(getpricesProvider(widget.match.matchId)).when(
              data: (prices) {
                double totalPrice;
                switch (widget.category) {
                  case 'VVIP':
                    totalPrice = prices.VVIP;
                    break;
                  case 'VIPA':
                    totalPrice = prices.VIPA;
                    break;
                  case 'VIPB':
                    totalPrice = prices.VIPB;
                    break;
                  case 'VIPC':
                    totalPrice = prices.VIPC;
                    break;
                  case 'ROUND':
                    totalPrice = prices.ROUND;
                    break;
                  case 'ORANGE':
                    totalPrice = prices.ORANGE;
                    break;
                  default:
                    totalPrice = 0.0;
                }

                final formattedPrice = NumberFormat("#,##0.00", "en_US").format(totalPrice);
                final formattedTax = NumberFormat("#,##0.00", "en_US").format(totalPrice / 10);

                return ListView(
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
                                  Text(user.email, textAlign: TextAlign.center),
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
                            const Text('Ticket Items', style: TextStyle(fontSize: 16)),
                            const SizedBox(height: 3),
                            const Divider(),
                            ListTile(
                              title: const Text("TicketNo:"),
                              trailing: Text(ticketNo),
                            ),
                            ListTile(
                              title: const Text("Match:"),
                              trailing: Text(matchToPlay),
                            ),
                            ListTile(
                              title: const Text("Date of Play:"),
                              trailing: Text(
                                "${widget.match.timestamp.day}/${widget.match.timestamp.month}/${widget.match.timestamp.year}",
                              ),
                            ),
                            ListTile(
                              title: const Text("Time of Play:"),
                              trailing: Text(
                                'Time: ${widget.match.timestamp.hour}:${widget.match.timestamp.minute.toString().padLeft(2, '0')}',
                              ),
                            ),
                            ListTile(
                              title: const Text("Stadium:"),
                              trailing: Text(widget.stadium.name),
                            ),
                            ListTile(
                              title: const Text("Seat Type:"),
                              trailing: Text(widget.blockName),
                            ),
                            ListTile(
                              title: const Text("Seat Number:"),
                              trailing: Text(widget.seatNumber.toString()),
                            ),
                            const Divider(),
                            DefaultTextStyle.merge(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text("Total Amount"),
                                      Text(formattedPrice),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text("Total Tax"),
                                      Text(formattedTax),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
              error: (error, st) => ErrorPage(error: error.toString()),
              loading: () => const SizedBox(),
            ),
    );
  }
}
