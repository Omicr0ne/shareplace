import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/core/config/supabase_config.dart';

void main() {
  tearDown(dotenv.clean);

  test('reads Supabase credentials from dotenv', () {
    dotenv.loadFromString(
      envString: '''
SUPABASE_URL=https://example.supabase.co
SUPABASE_ANON_KEY=example-anon-key
''',
    );

    final config = SupabaseConfig.fromDotenv();

    expect(config.url, 'https://example.supabase.co');
    expect(config.anonKey, 'example-anon-key');
  });
}
