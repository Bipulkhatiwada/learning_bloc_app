import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learning_bloc_app/Utils/enums.dart';

class ListDataModel extends Equatable {
  final String? title;
  final String? description;
  final String? icon;
  final XFile? image;
  final TodoStatus? todoStatus;

  const ListDataModel({  // Add const for better performance
    this.title,
    this.description,
    this.icon,
    this.image,
    this.todoStatus,
  });

  ListDataModel copyWith({
    String? title,
    String? description,
    String? icon,
    XFile? image,
    TodoStatus? todoStatus,
  }) {
    return ListDataModel(
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      image: image ?? this.image,
      todoStatus: todoStatus ?? this.todoStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
      'image': image?.path, // Store the path instead of XFile object
      'todoStatus': todoStatus?.name, // Convert enum to string
    };
  }

  factory ListDataModel.fromJson(Map<String, dynamic> json) {
    return ListDataModel(
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      image: json['image'] != null ? XFile(json['image']) : null,
      todoStatus: json['todoStatus'] != null 
          ? TodoStatus.values.firstWhere(
              (e) => e.name == json['todoStatus'],
              orElse: () => TodoStatus.pending // provide a default value
            )
          : null,
    );
  }

  @override
  List<Object?> get props => [title, description, icon, image, todoStatus];
}