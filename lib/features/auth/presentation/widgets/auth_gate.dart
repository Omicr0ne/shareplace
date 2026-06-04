import 'package:flutter/material.dart';
import 'package:shareplace/features/auth/presentation/pages/sign_in_page.dart';
import 'package:shareplace/features/home/presentation/pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  SupabaseClient? _clientOrNull() {
    try {
      return Supabase.instance.client;
    } on Object {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = _clientOrNull();
    if (client == null) {
      return const SignInPage();
    }

    return StreamBuilder<AuthState>(
      stream: client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final session = snapshot.hasData ? snapshot.data!.session : null;
        if (session != null) {
          return const HomePage();
        }
        return const SignInPage();
      },
    );
  }
}
