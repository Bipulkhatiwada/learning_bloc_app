

import 'package:equatable/equatable.dart';
import 'package:learning_bloc_app/models/notes_model.dart';

class NoteEvent extends Equatable {

const NoteEvent();


@override
  List<Object?> get props => [];

}


class FetchListEvent extends NoteEvent {}

class AddNoteEvent extends NoteEvent {


  final NotesModel note;

  const AddNoteEvent({required this.note});

  @override
  List<Object> get props => [note];

}
class EditNoteEvent extends NoteEvent {


  final NotesModel note;

  const EditNoteEvent({required this.note});

  @override
  List<Object> get props => [note];

}

class DeleteNoteEvent extends NoteEvent {
 final NotesModel note;

  const DeleteNoteEvent({required this.note});

  @override
  List<Object> get props => [note];


}