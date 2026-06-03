import 'package:flutter/material.dart';

class ProfileIdentityFields extends StatelessWidget {
  const ProfileIdentityFields({
    required this.firstName,
    required this.lastName,
    required this.onFirstNameChanged,
    required this.onLastNameChanged,
    super.key,
  });

  final String firstName;
  final String lastName;
  final ValueChanged<String> onFirstNameChanged;
  final ValueChanged<String> onLastNameChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          key: const Key('profile-first-name-field'),
          initialValue: firstName,
          autovalidateMode: AutovalidateMode.always,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Prénom',
          ),
          onChanged: (value) {
            final trimmedValue = value.trim();
            if (trimmedValue.isNotEmpty) {
              onFirstNameChanged(trimmedValue);
            }
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Le prénom est obligatoire';
            }

            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          key: const Key('profile-last-name-field'),
          initialValue: lastName,
          autovalidateMode: AutovalidateMode.always,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nom',
          ),
          onChanged: (value) {
            final trimmedValue = value.trim();
            if (trimmedValue.isNotEmpty) {
              onLastNameChanged(trimmedValue);
            }
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Le nom est obligatoire';
            }

            return null;
          },
        ),
      ],
    );
  }
}
