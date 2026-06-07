import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  const SupabaseConfig({
    required this.url,
    required this.anonKey,
  });

  factory SupabaseConfig.fromDotenv() {
    return SupabaseConfig(
      url: dotenv.get('SUPABASE_URL'),
      anonKey: dotenv.get('SUPABASE_ANON_KEY'),
    );
  }

  final String url;
  final String anonKey;
}
