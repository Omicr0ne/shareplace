import 'package:supabase_flutter/supabase_flutter.dart';

String authErrorMessage(Object error) {
  if (error is AuthException && error.statusCode == '429') {
    return 'Trop de demandes ont été envoyées. '
        'Réessayez dans quelques minutes.';
  }

  return error.toString();
}
