import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/credential.dart';

class AppsWebsitesScreen extends StatefulWidget {
  const AppsWebsitesScreen({super.key});

  @override
  State<AppsWebsitesScreen> createState() => _AppsWebsitesScreenState();
}

class _AppsWebsitesScreenState extends State<AppsWebsitesScreen> {
  final Box<Credential> box = Hive.box<Credential>('credentials');

  final _siteController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  void _showCredentialForm({Credential? existing, int? index}) {
    if (existing != null) {
      _siteController.text = existing.site;
      _userController.text = existing.username;
      _passController.text = existing.password;
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              existing != null ? "Edit Credential" : "Add Credential",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextField(controller: _siteController, decoration: const InputDecoration(labelText: "Website/App")),
            TextField(controller: _userController, decoration: const InputDecoration(labelText: "Username")),
            TextField(
              controller: _passController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Save"),
              onPressed: () {
                final newEntry = Credential(
                  site: _siteController.text.trim(),
                  username: _userController.text.trim(),
                  password: _passController.text.trim(),
                );
                if (existing != null && index != null) {
                  box.putAt(index, newEntry);
                } else {
                  box.add(newEntry);
                }

                _siteController.clear();
                _userController.clear();
                _passController.clear();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Credential"),
        content: const Text("Are you sure you want to delete this entry?"),
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
      appBar: AppBar(title: const Text("Apps & Websites")),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (_, Box<Credential> box, __) {
          final items = box.values.toList();
          if (items.isEmpty) {
            return const Center(child: Text("No saved credentials yet."));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, index) {
              final cred = items[index];
              return ListTile(
                leading: const Icon(Icons.lock),
                title: Text(cred.site),
                subtitle: Text(cred.username),
                onTap: () => _showCredentialForm(existing: cred, index: index),
                onLongPress: () => _showDeleteDialog(index),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCredentialForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
