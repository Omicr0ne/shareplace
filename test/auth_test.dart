import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/core/config/supabase_config.dart';
import 'package:shareplace/features/auth/data/auth_error_messages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('SupabaseConfig', () {
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
  });

  group('authErrorMessage', () {
    test('explains Supabase email rate limit errors', () {
      const error = AuthException(
        'For security purposes, you can only request this after 60 seconds',
        statusCode: '429',
      );

      expect(
        authErrorMessage(error),
        'Trop de demandes ont été envoyées. Réessayez dans quelques minutes.',
      );
    });

    test('keeps the original message for unknown errors', () {
      expect(
        authErrorMessage(StateError('Unexpected')),
        contains('Unexpected'),
      );
    });
  });
}
