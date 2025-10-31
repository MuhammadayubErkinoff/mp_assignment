import 'package:flutter/material.dart';
import '../note_model.dart';
import '../notes_database.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final data = await NotesDatabase.instance.getNotes();
    setState(() => _notes = data.map((e) => Note.fromMap(e)).toList());
  }

  Future<void> _confirmAndDelete(int id) async {
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

    if (confirmed == true) {
      await NotesDatabase.instance.delete(id);
      if (context.mounted) _loadNotes();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('My Notes')),
    body: _notes.isEmpty
        ? const Center(child: Text('No notes yet'))
        : ListView.builder(
      itemCount: _notes.length,
      itemBuilder: (_, i) {
        final note = _notes[i];
        return ListTile(
          title: Text(note.title),
          subtitle: Text(note.content, maxLines: 1, overflow: TextOverflow.ellipsis),
          onTap: () async {
            final shouldRefresh = await Navigator.pushNamed(context, '/detail', arguments: note) as bool?;
            if (shouldRefresh == true) _loadNotes();
          },
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              if (note.id != null) _confirmAndDelete(note.id!);
            },
          ),
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () async {
        await Navigator.pushNamed(context, '/addEdit');
        _loadNotes();
      },
      child: const Icon(Icons.add),
    ),
  );
}