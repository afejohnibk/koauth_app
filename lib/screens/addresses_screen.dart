import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/address.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  late Box<Address> box;

  final _labelController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    box = Hive.box<Address>('addresses');
  }

  void _clearForm() {
    _labelController.clear();
    _streetController.clear();
    _cityController.clear();
    _stateController.clear();
    _postalCodeController.clear();
    _countryController.clear();
  }

  void _showForm({Address? existing, int? index}) {
    if (existing != null) {
      _labelController.text = existing.label;
      _streetController.text = existing.street;
      _cityController.text = existing.city;
      _stateController.text = existing.state;
      _postalCodeController.text = existing.postalCode;
      _countryController.text = existing.country;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          top: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(existing != null ? "Edit Address" : "Add Address", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(controller: _labelController, decoration: const InputDecoration(labelText: "Label")),
              TextField(controller: _streetController, decoration: const InputDecoration(labelText: "Street")),
              TextField(controller: _cityController, decoration: const InputDecoration(labelText: "City")),
              TextField(controller: _stateController, decoration: const InputDecoration(labelText: "State")),
              TextField(controller: _postalCodeController, decoration: const InputDecoration(labelText: "Postal Code")),
              TextField(controller: _countryController, decoration: const InputDecoration(labelText: "Country")),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Save"),
                onPressed: () {
                  final newAddress = Address(
                    label: _labelController.text.trim(),
                    street: _streetController.text.trim(),
                    city: _cityController.text.trim(),
                    state: _stateController.text.trim(),
                    postalCode: _postalCodeController.text.trim(),
                    country: _countryController.text.trim(),
                  );
                  if (existing != null && index != null) {
                    box.putAt(index, newAddress);
                  } else {
                    box.add(newAddress);
                  }
                  _clearForm();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Address"),
        content: const Text("Are you sure you want to delete this address?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              box.deleteAt(index);
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Addresses")),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (_, Box<Address> box, __) {
          final items = box.values.toList();
          if (items.isEmpty) {
            return const Center(child: Text("No saved addresses."));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, index) {
              final address = items[index];
              return ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(address.label),
                subtitle: Text(
                  "${address.street}, ${address.city}, ${address.state}, ${address.postalCode}, ${address.country}",
                ),
                onTap: () => _showForm(existing: address, index: index),
                onLongPress: () => _showDeleteDialog(index),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
