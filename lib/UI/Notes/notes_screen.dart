import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_bloc_app/Boxes/boxes.dart';
import 'package:learning_bloc_app/models/notes_model.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key, required this.title});

  final String title;

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _buildNotesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNotesList() {
    return ValueListenableBuilder<Box<NotesModel>>(
      valueListenable: Boxes.getData().listenable(),
      builder: (context, box, _) {
        final notes = box.values.toList().cast<NotesModel>();
        if (notes.isEmpty) {
          return const Center(
            child: Text('No notes yet. Tap + to add one!'),
          );
        }

        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) => _buildNoteCard(notes[index]),
        );
      },
    );
  }


  Widget _buildNoteCard(NotesModel note) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          note.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(note.description),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showNoteDialog(existingNote: note),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteNote(note),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showNoteDialog({NotesModel? existingNote}) async {
    if (existingNote != null) {
      _titleController.text = existingNote.title;
      _descriptionController.text = existingNote.description;
    } else {
      _titleController.clear();
      _descriptionController.clear();
    }

    return showDialog(
      context: context,
      builder: (context) => AlertDialog (
        title: Text(existingNote == null ? 'Add Note' : 'Edit Note'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => _saveNote(existingNote),
            child: Text(existingNote == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _saveNote(NotesModel? existingNote) {
    if (_titleController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter a title');
      return;
    }

    final note = NotesModel(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    if (existingNote != null) {
      existingNote.title = note.title;
      existingNote.description = note.description;
      existingNote.save();
    } else {
      final box = Boxes.getData();
      box.add(note);
      note.save();
    }

    Navigator.pop(context);
    _showSuccessSnackBar(existingNote == null ? 'Note added' : 'Note updated');
  }

  Future<void> _deleteNote(NotesModel note) async {
  // Show confirmation dialog
  final bool confirmDelete = await showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Delete Note'),
      content: Text('Are you sure you want to delete "${note.title}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text('Delete'),
        ),
      ],
    ),
  ) ?? false; // Default to false if dialog is dismissed

  // If user confirmed deletion
  if (confirmDelete && mounted) {
    try {
      await note.delete();
      if (mounted) {
        _showSuccessSnackBar('Note deleted successfully');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to delete note');
      }
    }
  }
}

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}