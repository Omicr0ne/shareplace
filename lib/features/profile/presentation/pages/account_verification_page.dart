import 'package:flutter/material.dart';
import 'package:shareplace/app/app_routes.dart';

class AccountVerificationPage extends StatelessWidget {
  const AccountVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verification du compte')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Entrez votre email puis le code de verification a 6 chiffres.',
            ),
            const SizedBox(height: 16),
            const TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Adresse email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),
            const _SixDigitCodeField(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {},
                child: const Text('Verifier le compte'),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(onPressed: () {}, child: const Text('Renvoyer le code')),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
              child: const Text('Aller a la recherche'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SixDigitCodeField extends StatelessWidget {
  const _SixDigitCodeField();

  @override
  Widget build(BuildContext context) {
    return const TextField(
      keyboardType: TextInputType.number,
      maxLength: 6,
      decoration: InputDecoration(
        labelText: 'Code a 6 chiffres',
        hintText: '123456',
        counterText: '',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.pin_outlined),
      ),
    );
  }
}
