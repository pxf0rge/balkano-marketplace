import 'dart:io';
import 'package:Balkano/features/splash/presentation/pages/splash_screen.dart';
import 'package:Balkano/providers/chat_filter_provider.dart';
import 'package:Balkano/providers/chat_provider.dart';
import 'package:Balkano/providers/market_search_provider.dart';
import 'package:Balkano/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/io_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final innerHttpClient = HttpClient()
    ..connectionTimeout = const Duration(seconds: 30);
  final client = IOClient(innerHttpClient);

  await Supabase.initialize(
    url: 'https://xzeiefthcxbggnqruvvx.supabase.co',
    anonKey: 'sb_publishable__hsBtsvnjqnzpQwG9vxZ_g_-WuhYEc4',
    httpClient: client,
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('hr'), Locale('de')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MarketSearchProvider()),
          ChangeNotifierProvider(create: (context) => SearchProvider()),
          ChangeNotifierProvider(create: (_) => ChatFilterProvider()),
          ChangeNotifierProvider(create: (_) => ChatProvider()),
        ],
        child: const MainEntry(),
      ),
    ),
  );
}

class MainEntry extends StatefulWidget {
  const MainEntry({super.key});

  @override
  State<MainEntry> createState() => _MainEntryState();
}

class _MainEntryState extends State<MainEntry> with WidgetsBindingObserver {
  final client = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,

      home: Scaffold(body: SafeArea(child: _buildHomePage())),
    );
  }

  Widget _buildHomePage() => const SplashScreen();
}
