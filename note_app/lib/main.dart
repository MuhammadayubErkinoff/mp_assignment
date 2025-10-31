import 'package:flutter/material.dart';
import 'screens/notes_list_screen.dart';
import 'screens/add_edit_note_screen.dart';
import 'screens/note_detail_screen.dart';

void main() {
  runApp(MaterialApp(
    title: 'CRUD Notes App',
    initialRoute: '/',
    routes: {
      '/': (context) => const NotesListScreen(),
      '/addEdit': (context) => const AddEditNoteScreen(),
      '/detail': (context) => const NoteDetailScreen(),
    },
  ));
}