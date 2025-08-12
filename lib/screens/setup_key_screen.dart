import 'package:flutter/material.dart';

class SetupKeyScreen extends StatefulWidget {
  final Function(Map<String, String>) onSave;

  const SetupKeyScreen({super.key, required this.onSave});

  @override
  State<SetupKeyScreen> createState() => _SetupKeyScreenState();
}

class _SetupKeyScreenState extends State<SetupKeyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _issuerController = TextEditingController();
  final _accountController = TextEditingController();
  final _secretController = TextEditingController();

  final _base32RegExp = RegExp(r'^[A-Z2-7]+$'); // valid characters only

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Setup Key")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _issuerController,
                decoration: const InputDecoration(labelText: "Issuer (e.g. Google)"),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _accountController,
                decoration: const InputDecoration(labelText: "Account Name (optional)"),
              ),
              TextFormField(
                controller: _secretController,
                decoration: const InputDecoration(labelText: "Secret Key"),
                validator: (val) {
                  final clean = val!.trim().toUpperCase();
                  if (clean.isEmpty) return 'Required';
                  if (!_base32RegExp.hasMatch(clean)) {
                    return 'Invalid Base32 format (A–Z, 2–7 only)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Save"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final issuer = _issuerController.text.trim();
                    final account = _accountController.text.trim();
                    final secret = _secretController.text
                        .trim()
                        .toUpperCase()
                        .replaceAll(RegExp(r'[^A-Z2-7]'), '');

                    widget.onSave({
                      'issuer': issuer,
                      'account': account,
                      'secret': secret,
                    });

                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
