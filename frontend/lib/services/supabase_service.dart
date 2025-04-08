import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? 'http://localhost:8000',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? 'your-anon-key',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
} 