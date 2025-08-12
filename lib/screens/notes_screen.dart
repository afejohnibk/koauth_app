import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/secure_note.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final Box<SecureNote> box = Hive.box<SecureNote>('notes');

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void _clearForm() {
    _titleController.clear();
    _contentController.clear();
  }

  void _showForm({SecureNote? existing, int? index}) {
    if (existing != null) {
      _titleController.text = existing.title;
      _contentController.text = existing.content;
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
            Text(existing != null ? "Edit Note" : "Add Note", style: Theme.of(context).textTheme.titleLarge),
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: "Title")),
            TextField(controller: _contentController, decoration: const InputDecoration(labelText: "Content")),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Save"),
              onPressed: () {
                final newNote = SecureNote(
                  title: _titleController.text.trim(),
                  content: _contentController.text.trim(),
                );
                if (existing != null && index != null) {
                  box.putAt(index, newNote);
                } else {
                  box.add(newNote);
                }
                _clearForm();
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Note"),
        content: const Text("Are you sure you want to delete this note?"),
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
      appBar: AppBar(title: const Text("Secure Notes")),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (_, Box<SecureNote> box, __) {
          final items = box.values.toList();
          if (items.isEmpty) {
            return const Center(child: Text("No notes added yet."));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, index) {
              final note = items[index];
              return ListTile(
                leading: const Icon(Icons.note),
                title: Text(note.title),
                subtitle: Text(note.content, maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () => _showForm(existing: note, index: index),
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
