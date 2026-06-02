import 'package:shareplace/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shareplace/auth/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Login
    try {
      await authService.signInWithEmailPassword(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: "email"),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: "password"),
          ),
          ElevatedButton(onPressed: login, child: const Text("Login")),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterPage()),
            ),
            child: const Center(child: Text("Sign Up")),
          ),
        ],
      ),
    );
  }
}
