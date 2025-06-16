import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/config/supabase_config.dart';
import 'package:sport_ticketing/firebase_options.dart';
import 'package:sport_ticketing/pages/error_page.dart';
import 'package:sport_ticketing/pages/home_page.dart';
import 'package:sport_ticketing/pages/loading_page.dart';
import 'package:sport_ticketing/pages/login_page.dart';
import 'package:sport_ticketing/providers/auth_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Load .env in production mode, .env.development otherwise
  await dotenv.load(fileName: kReleaseMode ? '.env' : '.env.development');

  print('Initializing Firebase...');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Firebase initialized.');

  print('Initializing Supabase...');
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );
  print('Supabase initialized.');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      home: ref.watch(currentUserAccountProvider).when(
            data: (user) {
              if (user != null) {
                return const HomePage();
              }
              return const LoginPage();
            },
            error: (error, st) => ErrorPage(
              error: error.toString(),
            ),
            loading: () => const LoadingPage(),
          ),
    );
  }
}
