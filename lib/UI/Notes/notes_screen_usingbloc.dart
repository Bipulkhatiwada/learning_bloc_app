// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_bloc_app/bloc/Notes/note_bloc.dart';
import 'package:learning_bloc_app/bloc/Notes/note_event.dart';
import 'package:learning_bloc_app/bloc/Notes/note_states.dart';
import 'package:learning_bloc_app/models/notes_model.dart';

class NotesScreenBLoc extends StatefulWidget {
  const NotesScreenBLoc({super.key, required this.title});

  final String title;

  @override
  State<NotesScreenBLoc> createState() => _NotesScreenBLocState();
}

class _NotesScreenBLocState extends State<NotesScreenBLoc> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<NoteBloc>().add(FetchListEvent());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteBloc, NoteStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: _buildNotesListUsingBloc(state.noteList),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showNoteDialog(context),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildNotesListUsingBloc(List<NotesModel> noteList) {
        if (noteList.isEmpty) {
          return const Center(
            child: Text(
              'No notes yet. Tap + to add one!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: noteList.length,
          itemBuilder: (_, index) {
            return _buildNoteCard(context, noteList[index]);
          },
        );
  }

  Widget _buildNoteCard(BuildContext context, NotesModel note) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          note.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            note.description,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showNoteDialog(context, existingNote: note),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteNote(context, note),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showNoteDialog(BuildContext context,
      {NotesModel? existingNote}) async {
    // Set the text controllers' values if editing an existing note
    if (existingNote != null) {
      _titleController.text = existingNote.title;
      _descriptionController.text = existingNote.description;
    } else {
      _titleController.clear();
      _descriptionController.clear();
    }

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          existingNote == null ? 'Add Note' : 'Edit Note',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Title is required";
                    }
                    return null;
                  },
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Description is required";
                    }
                    return null;
                  },
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => _saveNote(context, existingNote),
            child: Text(existingNote == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _saveNote(BuildContext context, NotesModel? existingNote) {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    // if (_formkey.currentState!.validate()) {
    //   context.read<NoteBloc>().add(EditNoteEvent(
    //       note: NotesModel(title: title, description: description)));
    //   Navigator.pop(context);
    //   _showSuccessSnackBar(
    //       existingNote == null ? 'Note added' : 'Note updated');
    // }

    // Validate input
    if (title.isEmpty) {
      _showErrorSnackBar('Please enter a title');
      return;
    }

    if (existingNote != null) {
      existingNote.title = title;
      existingNote.description = description;

      // Trigger edit event
      context.read<NoteBloc>().add(EditNoteEvent(note: existingNote));
    } else {
      // Create new note
      final note = NotesModel(
        title: title,
        description: description,
      );

      context.read<NoteBloc>().add(AddNoteEvent(note: note));
    }
      context.read<NoteBloc>().add(FetchListEvent());

      // setStates(() {});
      Navigator.pop(context);
        _showSuccessSnackBar(
          existingNote == null ? 'Note added' : 'Note updated');
    

  }

  Future<void> _deleteNote(BuildContext context, NotesModel note) async {
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
        ) ??
        false;

    if (confirmDelete && mounted) {
      try {
        context.read<NoteBloc>().add(DeleteNoteEvent(note: note));
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
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 61, 63, 62),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
