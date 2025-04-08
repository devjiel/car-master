import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'theme/app_theme.dart';
import 'screens/game_screen.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Chargement du fichier .env
  await dotenv.load(fileName: ".env");
  
  // Initialisation de Supabase avec les variables d'environnement
  await SupabaseService.initialize();
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Master',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const GameScreen(),
    );
  }
}
