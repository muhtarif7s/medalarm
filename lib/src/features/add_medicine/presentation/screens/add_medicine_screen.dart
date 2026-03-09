import 'package:flutter/material.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/add_medicine/presentation/widgets/add_medicine_form.dart';

class AddMedicineScreen extends StatelessWidget {
  const AddMedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addMedication),
      ),
      body: const SingleChildScrollView(
        child: AddMedicineForm(),
      ),
    );
  }
}
