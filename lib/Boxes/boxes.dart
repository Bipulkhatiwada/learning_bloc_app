

import 'package:hive/hive.dart';
import 'package:learning_bloc_app/models/notes_model.dart';

class Boxes{

  static Box<NotesModel> getData() => Hive.box<NotesModel>('notes');
  
}