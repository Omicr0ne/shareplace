import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/features/auth/data/auth_error_messages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
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
}
