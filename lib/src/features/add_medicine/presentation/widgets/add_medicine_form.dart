import 'package:flutter/material.dart';
import 'package:myapp/src/features/add_medicine/presentation/widgets/frequency_selector.dart';
import 'package:myapp/src/features/add_medicine/presentation/widgets/start_date_selector.dart';
import 'package:myapp/src/features/add_medicine/presentation/widgets/time_selector.dart';

class AddMedicineForm extends StatefulWidget {
  const AddMedicineForm({super.key});

  @override
  State<AddMedicineForm> createState() => _AddMedicineFormState();
}

class _AddMedicineFormState extends State<AddMedicineForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Medicine Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Dosage',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const FrequencySelector(),
            const SizedBox(height: 16),
            const TimeSelector(),
            const SizedBox(height: 16),
            const StartDateSelector(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Save'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
