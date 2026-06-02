import 'package:flutter/material.dart';
import 'package:shareplace/auth/pages/login_page.dart';
import 'package:shareplace/auth/pages/profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // Listen to auth state changes
      stream: Supabase.instance.client.auth.onAuthStateChange,
      // Build page
      builder: (context, snapshot) {
        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // Check if there is a valid session
        final session = snapshot.hasData ? snapshot.data!.session : null;
        if (session != null) {
          return const ProfilePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
