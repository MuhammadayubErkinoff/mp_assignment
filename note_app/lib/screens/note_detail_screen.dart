import 'package:flutter/material.dart';
import '../note_model.dart';
import '../notes_database.dart';

class NoteDetailScreen extends StatefulWidget {
  const NoteDetailScreen({super.key});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late Note _note;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is Note) _note = args;
  }

  Future<void> _edit() async {
    await Navigator.pushNamed(context, '/addEdit', arguments: _note);
    if (_note.id != null) {
      final rows = await NotesDatabase.instance.getNotes();
      final updated = rows.map((e) => Note.fromMap(e)).firstWhere((n) => n.id == _note.id, orElse: () => _note);
      setState(() => _note = updated);
    }
  }

  Future<void> _confirmAndDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete note?'),
        content: const Text('This action cannot be undone. Do you want to delete this note?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && _note.id != null) {
      await NotesDatabase.instance.delete(_note.id!);
      if (context.mounted) Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(_note.title),
      actions: [
        IconButton(icon: const Icon(Icons.edit), onPressed: _edit),
        IconButton(icon: const Icon(Icons.delete), onPressed: _confirmAndDelete),
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Text(_note.content.isEmpty ? '(no content)' : _note.content, style: const TextStyle(fontSize: 16)),
      ),
    ),
  );
}