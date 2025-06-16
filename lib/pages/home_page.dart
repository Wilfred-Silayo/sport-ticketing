import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/pages/error_page.dart';
import 'package:sport_ticketing/pages/loading_page.dart';
import 'package:sport_ticketing/pages/search_screen.dart';
import 'package:sport_ticketing/providers/match_provider.dart';
import 'package:sport_ticketing/widgets/drawer.dart';
import 'package:sport_ticketing/widgets/match_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: const Text(
            'Football',
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Search(),
                  ),
                );
              },
              icon: const Icon(
                Icons.search,
                size: 30,
              ),
            ),
          ]),
      drawer: const DrawerWidget(),
      body: ref.watch(getMatchesProvider).when(
            data: (matches) {
              return ListView.builder(
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final match = matches[index];
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
