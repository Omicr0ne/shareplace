import 'package:flutter/material.dart';
import 'package:shareplace/app/app_routes.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});
  static const String routeName = AppRoutes.forgotPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF151515),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 24,
                      offset: Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _PageHeader(title: 'Mot de passe oublie'),
                    const SizedBox(height: 20),
                    const Text(
                      'Entrez votre email et le code de verification a '
                      '6 chiffres.',
                      style: TextStyle(color: Color(0xFFC9C9C9)),
                    ),
                    const SizedBox(height: 16),
                    const _StyledTextField(
                      label: 'Adresse email',
                      hintText: 'votre@email.com',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 16),
                    const _SixDigitCodeField(),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFFA500),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Valider',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.studentVerification,
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFFFA500),
                      ),
                      child: const Text('Aller a verification du compte'),
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
}

class _SixDigitCodeField extends StatelessWidget {
  const _SixDigitCodeField();

  @override
  Widget build(BuildContext context) {
    return const _StyledTextField(
      label: 'Code a 6 chiffres',
      hintText: '123456',
      keyboardType: TextInputType.number,
      maxLength: 6,
      prefixIcon: Icons.pin_outlined,
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              padding: EdgeInsets.zero,
              splashRadius: 22,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFFA500),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _StyledTextField extends StatelessWidget {
  const _StyledTextField({
    required this.label,
    required this.hintText,
    required this.keyboardType,
    this.maxLength,
    this.prefixIcon,
  });

  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final int? maxLength;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: keyboardType,
          maxLength: maxLength,
          style: const TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            counterText: maxLength == null ? null : '',
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFF7A7A7A)),
            filled: true,
            fillColor: const Color(0xFFE9E9E9),
            prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFFFA500),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
