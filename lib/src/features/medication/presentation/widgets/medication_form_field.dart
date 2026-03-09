import 'package:flutter/material.dart';

class MedicationFormField extends StatelessWidget {
  final String label;
  final String initialValue;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const MedicationFormField({
    super.key,
    required this.label,
    required this.initialValue,
    this.onSaved,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
    );
  }
}
