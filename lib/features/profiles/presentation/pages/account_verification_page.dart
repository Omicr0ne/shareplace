import 'package:flutter/material.dart';
import 'package:shareplace/app/app_routes.dart';
import 'package:shareplace/app/app_theme.dart';
import 'package:shareplace/core/widgets/app_page_scaffold.dart';

class AccountVerificationPage extends StatelessWidget {
  const AccountVerificationPage({super.key});
  static const String routeName = AppRoutes.studentVerification;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Verification du compte',
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 24,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Entrez votre email puis le code de verification a '
                    '6 chiffres.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.darkBrown,
                    ),
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
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Verifier le compte',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                    child: const Text('Renvoyer le code'),
                  ),
                ],
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
            color: AppColors.darkBrown,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: keyboardType,
          maxLength: maxLength,
          style: const TextStyle(color: AppColors.darkBrown),
          decoration: InputDecoration(
            counterText: maxLength == null ? null : '',
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFF7A7A7A)),
            filled: true,
            fillColor: Colors.white,
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
                color: AppColors.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
