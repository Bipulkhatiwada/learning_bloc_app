import 'package:equatable/equatable.dart';
import 'package:learning_bloc_app/models/notes_model.dart';

// ignore: must_be_immutable
class NoteStates extends Equatable {
  List<NotesModel> noteList = [];

  NoteStates({
    this.noteList = const [],
  });

  NoteStates copyWith({
    List<NotesModel>? noteList
    }) {
    return NoteStates(
      noteList: noteList ?? this.noteList);
  }

  @override
  List<Object?> get props => [noteList];
}
