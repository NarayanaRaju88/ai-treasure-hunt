import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'config/firebase_config.dart';
import 'config/hive_config.dart';
import 'core/di/service_locator.dart';
import 'presentation/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive
  await Hive.initFlutter();
  await HiveConfig.initializeHive();

  // Setup Service Locator (Dependency Injection)
  setupServiceLocator();

  runApp(
    const ProviderScope(
      child: AITreasureHuntApp(),
    ),
  );
}
