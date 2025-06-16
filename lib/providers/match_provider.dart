import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/apis/match_api.dart';
import 'package:sport_ticketing/models/match_model.dart';

final matchControllerProvider = StateNotifierProvider<MatchController, bool>(
  (ref) => MatchController(
    matchAPI: ref.watch(matchAPIProvider),
  ),
);

final getMatchesProvider = StreamProvider(
  (ref) => ref.watch(matchControllerProvider.notifier).getMatches(),
);

final getNextMatchesProvider = StreamProvider.family(
  (ref, MatchModel match) => ref.watch(matchControllerProvider.notifier).getNextMatches(match),
);

final searchMatchProvider = StreamProvider.family((ref, String query) {
  final matchController = ref.watch(matchControllerProvider.notifier);
  return matchController.searchMatch(query);
});

final getMatchProvider = FutureProvider.family(
  (ref, String id) => ref.watch(matchControllerProvider.notifier).getmatch(id),
);

class MatchController extends StateNotifier<bool> {
  final MatchAPI _matchAPI;
  MatchController({required MatchAPI matchAPI})
      : _matchAPI = matchAPI,
        super(false);

  Stream<List<MatchModel>> getMatches() {
    return _matchAPI.getMatches();
  }

  Stream<List<MatchModel>> getNextMatches(MatchModel match) {
    return _matchAPI.getNextMatches(match);
  }

  Future<MatchModel> getmatch(String id) async {
    return _matchAPI.getMatch(id);
  }

  Stream<List<MatchModel>> searchMatch(String query) {
    return _matchAPI.searchMatch(query);
  }
}
