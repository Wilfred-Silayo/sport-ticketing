import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/pages/error_page.dart';
import 'package:sport_ticketing/pages/profile.dart';
import 'package:sport_ticketing/pages/security.dart';
import 'package:sport_ticketing/pages/tickets.dart';
import 'package:sport_ticketing/pages/user_account.dart';
import 'package:sport_ticketing/providers/auth_provider.dart';
import 'package:sport_ticketing/widgets/circular_avator.dart';
import 'package:sport_ticketing/widgets/dialog.dart';
import '../pages/loading_page.dart';

class DrawerWidget extends ConsumerStatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends ConsumerState<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return ref
        .watch(currentUserDetailsProvider)
        .when(
          data: (user) {
            return Drawer(
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                    decoration: const BoxDecoration(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomCircularAvator(
                          photoUrl: user.profilePic,
                          radius: 40,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  user.username,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text(
                      "Profile",
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserProfileView(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.history_edu),
                    title: const Text(
                      "Tickets",
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.push(context, UserTicketsView.route(user));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet),
                    title: const Text(
                      "Accounts",
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.push(context, AccountPage.route(user.uid));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text(
                      "Security",
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Security(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 60),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text("Logout", style: TextStyle(fontSize: 18)),
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialog(
                            title: 'Logout',
                            content: 'Are you sure you want to logout?',
                            onConfirm: () {
                              ref
                                  .read(authControllerProvider.notifier)
                                  .logout(context);
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
          error: (error, st) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
