import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sport_ticketing/providers/account_provider.dart';
import 'package:sport_ticketing/providers/account_state.dart';
import 'package:sport_ticketing/utils/show_dialog.dart' as sd;
import 'package:sport_ticketing/utils/utils.dart';

class AccountPage extends ConsumerStatefulWidget {
  final String userId;

  const AccountPage({super.key, required this.userId});

    static Route<dynamic> route(String userId) {
    return MaterialPageRoute(
      builder: (context) => AccountPage(
        userId: userId,
      ),
    );
  }

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  final depositController = TextEditingController();
  final withdrawController = TextEditingController();
  final _depositFormKey = GlobalKey<FormState>();
  final _withdrawFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    depositController.dispose();
    withdrawController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncAccount = ref.watch(accountStreamProvider(widget.userId));
    final accountNotifier = ref.watch(accountProvider.notifier);

    ref.listen<AccountState>(accountProvider, (previous, next) {
      if (next is AccountLoading) {
        sd.showLoadingDialog(context, message: 'Processing...');
      } else {
        sd.hideLoadingDialog(context);
      }

      if (next is AccountError) {
        showSnackBar(context, next.message);
      } else if (next is AccountLoaded) {
        if (depositController.text.isNotEmpty) {
          depositController.clear();
          showSnackBar(context, "Deposit successful!");
        } else if (withdrawController.text.isNotEmpty) {
          withdrawController.clear();
          showSnackBar(context, "Withdrawal successful!");
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Account Balance'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: asyncAccount.when(
          data:
              (account) => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Balance Card
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 24),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              'Available Balance',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              NumberFormat.currency(
                                symbol: 'TZS ',
                                decimalDigits: 2,
                              ).format(account?.balance ?? 0),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Deposit Section
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _depositFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Deposit Funds',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: depositController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Amount (TZS)',
                                  prefixIcon: Icon(Icons.add_circle_outline),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an amount';
                                  }
                                  final amount = double.tryParse(value);
                                  if (amount == null || amount <= 0) {
                                    return 'Please enter a valid amount';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.arrow_upward),
                                label: const Text('Deposit'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                onPressed: () {
                                  if (_depositFormKey.currentState!
                                      .validate()) {
                                    final amount = double.parse(
                                      depositController.text,
                                    );
                                    accountNotifier.deposit(
                                      widget.userId,
                                      amount,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Withdraw Section
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _withdrawFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Withdraw Funds',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: withdrawController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Amount (TZS)',
                                  prefixIcon: Icon(Icons.remove_circle_outline),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an amount';
                                  }
                                  final amount = double.tryParse(value);
                                  if (amount == null || amount <= 0) {
                                    return 'Please enter a valid amount';
                                  }
                                  if (account != null &&
                                      amount > account.balance) {
                                    return 'Insufficient funds';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.arrow_downward),
                                label: const Text('Withdraw'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                onPressed: () {
                                  if (_withdrawFormKey.currentState!
                                      .validate()) {
                                    final amount = double.parse(
                                      withdrawController.text,
                                    );
                                    accountNotifier.withdraw(
                                      widget.userId,
                                      amount,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (err, stack) =>
                  Center(child: Text('Error loading account: $err')),
        ),
      ),
    );
  }
}
