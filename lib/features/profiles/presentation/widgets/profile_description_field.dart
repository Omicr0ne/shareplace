import 'package:flutter/material.dart';

class ProfileDescriptionField extends StatelessWidget {
  const ProfileDescriptionField({
    required this.initialDescription,
    required this.onChanged,
    super.key,
  });

  final String initialDescription;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const Key('profile-description-field'),
      initialValue: initialDescription,
      maxLines: 5,
      minLines: 3,
      maxLength: 500,
      onChanged: onChanged,
      decoration: const InputDecoration(
        alignLabelWithHint: true,
        border: OutlineInputBorder(),
        labelText: 'Description',
        hintText: 'Présente-toi en quelques mots.',
      ),
      textInputAction: TextInputAction.newline,
    );
  }
}
