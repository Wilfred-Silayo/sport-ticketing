import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/apis/account_api.dart';
import 'package:sport_ticketing/models/account_model.dart';
import 'package:sport_ticketing/providers/account_state.dart';
import 'package:sport_ticketing/providers/firebase_providers.dart';

final accountProvider = StateNotifierProvider<AccountNotifier, AccountState>((
  ref,
) {
  final client = ref.watch(firebaseFirestoreProvider);
  return AccountNotifier(AccountAPI(client));
});

final userAccountProvider = FutureProvider.family<AccountModel, String>((
  ref,
  userId,
) {
  return ref.read(accountProvider.notifier).getAccountById(userId);
});

final accountStreamProvider = StreamProvider.family<AccountModel?, String>((
  ref,
  userId,
) {
  return ref.read(accountProvider.notifier).streamAccount(userId);
});

class AccountNotifier extends StateNotifier<AccountState> {
  final AccountAPI remote;

  AccountNotifier(this.remote) : super(AccountInitial());

  Future<AccountModel> getAccountById(String userId) async {
    final account = await remote.getAccount(userId);
    if (account != null) return account;
    return AccountModel(
      id: '',
      userId: userId,
      balance: 0.00,
      createdAt: DateTime.now(),
    );
  }

  Future<void> deposit(String userId, double amount) async {
    try {
      state = AccountLoading();
      final account = await remote.deposit(userId, amount);
      state = AccountLoaded(account);
    } catch (e) {
      state = AccountError(e.toString());
      rethrow;
    }
  }

  Future<void> withdraw(String userId, double amount) async {
    try {
      state = AccountLoading();
      final account = await remote.withdraw(userId, amount);
      state = AccountLoaded(account);
    } catch (e) {
      state = AccountError(e.toString());
      rethrow;
    }
  }

  Stream<AccountModel?> streamAccount(String userId) {
    return remote.streamAccount(userId);
  }
}
