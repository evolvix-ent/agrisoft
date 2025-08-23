import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'src/core/constants.dart';
import 'src/core/config/environment.dart';
import 'src/core/theme.dart';
import 'src/core/router.dart';
import 'src/core/database/database_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar base de datos local
  await DatabaseInitializer.initialize();

  // Inicializar Supabase
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  runApp(
    const ProviderScope(
      child: AgriSoftApp(),
    ),
  );
}

class AgriSoftApp extends ConsumerWidget {
  const AgriSoftApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'AgriSoft',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Español
        Locale('en', 'US'), // Inglés (fallback)
      ],
      locale: const Locale('es', 'ES'),
    );
  }
}
