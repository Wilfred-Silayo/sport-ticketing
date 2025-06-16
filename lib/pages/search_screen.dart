import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/pages/error_page.dart';
import 'package:sport_ticketing/providers/match_provider.dart';
import 'package:sport_ticketing/widgets/match_card.dart';

import 'loading_page.dart';

class Search extends ConsumerStatefulWidget {
  const Search({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchState();
}

class _SearchState extends ConsumerState<Search> {
  final searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarTextFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(
        color: Colors.blue,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: SizedBox(
          height: 50,
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                isShowUsers = true;
              });
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10).copyWith(
                left: 20,
              ),
              fillColor: Colors.white,
              filled: true,
              enabledBorder: appBarTextFieldBorder,
              focusedBorder: appBarTextFieldBorder,
              hintText: 'Search a match',
            ),
          ),
        ),
      ),
      body: isShowUsers && searchController.text.isNotEmpty
          ? ref.watch(searchMatchProvider(searchController.text)).when(
                data: (matches) {
                  return matches.isEmpty
                      ? const Center(
                          child: Text('No matches found'),
                        )
                      : ListView.builder(
                          itemCount: matches.length,
                          itemBuilder: (BuildContext context, int index) {
                            final match = matches[index];
                            return MatchCard(
                              match: match,
                            );
                          },
                        );
                },
                error: (error, st) => ErrorText(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              )
          : const SizedBox(),
    );
  }
}
