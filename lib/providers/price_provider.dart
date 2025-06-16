import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/apis/prices_api.dart';
import 'package:sport_ticketing/models/prices_model.dart';

final pricesControllerProvider =
    StateNotifierProvider<PricesController, bool>(
  (ref) => PricesController(
    pricesAPI: ref.watch(pricesAPIProvider),
  ),
);

final getpricesProvider = StreamProvider.family(
  (ref, String id) =>
      ref.watch(pricesControllerProvider.notifier).getPrices(id),
);

class PricesController extends StateNotifier<bool> {
  final PricesAPI _pricesAPI;
  PricesController({required PricesAPI pricesAPI})
      : _pricesAPI = pricesAPI,
        super(false);

  Stream<Prices> getPrices(String id) {
    return _pricesAPI.getPrices(id);
  }
}
