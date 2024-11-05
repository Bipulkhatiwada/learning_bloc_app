import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_bloc_app/Boxes/boxes.dart';
import 'package:learning_bloc_app/bloc/Notes/note_event.dart';
import 'package:learning_bloc_app/bloc/Notes/note_states.dart';
import 'package:learning_bloc_app/models/notes_model.dart';

class NoteBloc extends Bloc<NoteEvent, NoteStates> {
  NoteBloc() : super(NoteStates()) {
    on<FetchListEvent>(_fetchNotes);
    on<AddNoteEvent>(_addNotes);
    on<EditNoteEvent>(_editNotes);
    on<DeleteNoteEvent>(_deleteNotes);
  }

  void _fetchNotes(FetchListEvent event, Emitter<NoteStates> emit) {
    try {
      final notes = Boxes.getData().values.toList().cast<NotesModel>();
      emit(state.copyWith(noteList: notes));
    } catch (e) {
      log('Error fetching notes: $e');
    }
  }

  void _addNotes(AddNoteEvent event, Emitter<NoteStates> emit) {
    try {
      final box = Boxes.getData();
      final note = event.note;
      box.add(note);
      note.save();

      final notes = box.values.toList().cast<NotesModel>();
      emit(state.copyWith(noteList: notes));
    } catch (e) {
      log('Error adding note: $e');
    }
  }

  void _editNotes(EditNoteEvent event, Emitter<NoteStates> emit) {
    try {
      List<NotesModel> updatelist = List.from(state.noteList);
      final note = event.note;
;      note.save();
      final notes = Boxes.getData().values.toList().cast<NotesModel>();
      updatelist = notes;

      emit(state.copyWith(noteList: updatelist));
    } catch (e) {
      log('Error editing note: $e');
    }
  }

  void _deleteNotes(DeleteNoteEvent event, Emitter<NoteStates> emit) {
    try {
      final note = event.note;
      note.delete();

      final notes = Boxes.getData().values.toList().cast<NotesModel>();
      emit(state.copyWith(noteList: notes));
    } catch (e) {
      log('Error deleting note: $e');
    }
  }
}
