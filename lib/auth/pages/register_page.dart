import 'package:flutter/material.dart';
import 'package:shareplace/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authService = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords don't match")));
      return;
    }

    // Sing Up
    try {
      await authService.signUpWithEmailPassword(email, password);
      Navigator.pop(context);
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
          TextField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(labelText: "confirm password"),
          ),
          ElevatedButton(onPressed: signUp, child: const Text("Sign Up")),
        ],
      ),
    );
  }
}
