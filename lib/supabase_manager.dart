import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseManager {
  static late final SupabaseClient client;

  static Future<void> init() async {
    await dotenv.load();

    final String supabaseUrl = dotenv.env['SUPABASE_URL']!;
    final String supabaseKey = dotenv.env['SUPABASE_ANON_KEY']!;

    client = SupabaseClient(supabaseUrl, supabaseKey);

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  }
}
