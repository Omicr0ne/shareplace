import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shareplace/app/app_routes.dart';
import 'package:shareplace/features/auth/data/auth_error_messages.dart';
import 'package:shareplace/features/auth/data/auth_service.dart';
import 'package:shareplace/features/auth/presentation/pages/sign_up_success_page.dart';
import 'package:shareplace/features/profiles/data/repositories/profile_repository.dart';
import 'package:shareplace/features/profiles/data/repositories/supabase_profile_repository.dart';
import 'package:shareplace/features/profiles/domain/entities/profile.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    this.authService,
    this.profileRepository,
    super.key,
  });

  final AuthService? authService;
  final ProfileRepository? profileRepository;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  static const Color _backgroundColor = Colors.white;
  static const Color _accentColor = Color(0xFFE8890A);
  static const Color _textColor = Color(0xFF2F2F2F);
  static const Color _hintColor = Color(0xFFAAAAAA);
  static const Color _borderColor = Color(0xFFDDDDDD);

  final _formKey = GlobalKey<FormState>();
  late final AuthService _authService = widget.authService ?? AuthService();
  late final ProfileRepository _profileRepository =
      widget.profileRepository ?? SupabaseProfileRepository();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez renseigner $fieldName';
    }
    return null;
  }

  String? _phoneValidator(String? value) {
    final requiredError = _requiredValidator(value, 'le numéro de téléphone');
    if (requiredError != null) return requiredError;
    final phone = value!.trim();
    final isValid = RegExp(r'^\+?[0-9]{8,15}$').hasMatch(phone);
    if (!isValid) return 'Numéro de téléphone invalide';
    return null;
  }

  String? _emailValidator(String? value) {
    final requiredError = _requiredValidator(value, "l'email");
    if (requiredError != null) return requiredError;
    final email = value!.trim();
    final isValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!isValid) return 'Adresse email invalide';
    return null;
  }

  String? _passwordValidator(String? value) {
    final requiredError = _requiredValidator(value, 'le mot de passe');
    if (requiredError != null) return requiredError;
    if (value!.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    final requiredError = _requiredValidator(
      value,
      'la confirmation du mot de passe',
    );
    if (requiredError != null) return requiredError;
    if (value != _passwordController.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  Future<void> _goToStepTwo() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    try {
      final authResponse = await _authService.signUpWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );
      final authUser = authResponse.user;
      if (authUser == null) {
        throw StateError('Supabase did not return a user after sign up.');
      }
      final now = DateTime.now().toUtc();

      await _profileRepository.create(
        Profile(
          id: '',
          authUserId: authUser.id,
          firstName: _prenomController.text.trim(),
          lastName: _nomController.text.trim(),
          phone: _telephoneController.text.trim(),
          createdAt: now,
          updatedAt: now,
        ),
      );
    } on Object catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Inscription impossible : ${authErrorMessage(error)}'),
        ),
      );
      return;
    }

    if (!mounted) return;

    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const SignUpSuccessPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.maybePop(context),
                        icon: const Icon(Icons.arrow_back),
                        color: _textColor,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Créer un compte',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _accentColor,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _prenomController,
                      validator: (value) => _requiredValidator(value, 'prenom'),
                      style: const TextStyle(color: _textColor, fontSize: 15),
                      decoration: _inputDecoration('Prénom'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nomController,
                      validator: (value) => _requiredValidator(value, ' Nom '),
                      style: const TextStyle(color: _textColor, fontSize: 15),
                      decoration: _inputDecoration('Nom '),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: _emailValidator,
                      style: const TextStyle(color: _textColor, fontSize: 15),
                      decoration: _inputDecoration('Email'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _telephoneController,
                      keyboardType: TextInputType.phone,
                      validator: _phoneValidator,
                      style: const TextStyle(color: _textColor, fontSize: 15),
                      decoration: _inputDecoration('Numéro de téléphone'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      validator: _passwordValidator,
                      style: const TextStyle(color: _textColor, fontSize: 15),
                      decoration: _inputDecoration('Nouveau mot de passe'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      validator: _confirmPasswordValidator,
                      style: const TextStyle(color: _textColor, fontSize: 15),
                      decoration: _inputDecoration('Confirmer le mot de passe'),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accentColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () => unawaited(_goToStepTwo()),
                        child: const Text('Continuer'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.signIn),
                      style: TextButton.styleFrom(
                        foregroundColor: _hintColor,
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                      child: const Text("J'ai déjà un compte"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: _hintColor, fontSize: 15),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _accentColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }
}
