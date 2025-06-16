import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/pages/error_page.dart';
import 'package:sport_ticketing/pages/loading_page.dart';
import 'package:sport_ticketing/widgets/match_card.dart';
import 'package:sport_ticketing/providers/match_provider.dart';
import '../models/match_model.dart';

class NextMatch extends ConsumerWidget {
  final MatchModel matchModel;
  const NextMatch({super.key, required this.matchModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Next Matches"),
      ),
      body: ref.watch(getNextMatchesProvider(matchModel)).when(
            data: (matches) {
              if (matches == null || matches.length==1 && matches[0].matchId==matchModel.matchId) {
                return const ErrorText(
                  error: "No next matches have been uploaded",
                );
              }
              return ListView.builder(
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final match = matches[index];
                    if(matchModel.matchId==match.matchId){
                    return const SizedBox();
                    }
                    return MatchCard(match: match);
                  });
            },
            error: (error, st) {
              return ErrorPage(error: error.toString());
            },
            loading: () => const Loader(),
          ),
    );
  }
}
