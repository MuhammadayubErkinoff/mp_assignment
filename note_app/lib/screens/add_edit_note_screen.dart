import 'package:flutter/material.dart';
import '../note_model.dart';
import '../notes_database.dart';

class AddEditNoteScreen extends StatefulWidget {
  const AddEditNoteScreen({super.key});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  Note? editingNote;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is Note) {
      editingNote = args;
      _titleController.text = editingNote!.title;
      _contentController.text = editingNote!.content;
    }
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      if (editingNote == null) {
        await NotesDatabase.instance.insert(
          Note(title: _titleController.text, content: _contentController.text),
        );
      } else {
        await NotesDatabase.instance.update(
          Note(
            id: editingNote!.id,
            title: _titleController.text,
            content: _contentController.text,
          ),
        );
      }
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
        title: Text(editingNote == null ? 'Add Note' : 'Edit Note')),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
            validator: (val) =>
            val == null || val.isEmpty ? 'Enter a title' : null,
          ),
          TextFormField(
            controller: _contentController,
            decoration: const InputDecoration(labelText: 'Content'),
            maxLines: 5,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: _saveNote,
              child: Text(editingNote == null ? 'Save' : 'Update')),
        ]),
      ),
    ),
  );
}