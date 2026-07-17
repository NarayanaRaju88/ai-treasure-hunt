import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/theme_config.dart';
import '../core/providers/theme_provider.dart';
import 'routes/app_router.dart';

class AITreasureHuntApp extends ConsumerWidget {
  const AITreasureHuntApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    final goRouter = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'AI Treasure Hunt',
      debugShowCheckedModeBanner: false,
      theme: ThemeConfig.lightTheme,
      darkTheme: ThemeConfig.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: goRouter,
    );
  }
}
