import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class ListDataModel extends Equatable {
  String? title;
  String? description;
  String? icon;
  XFile? image;
  

  ListDataModel({this.title, this.description, this.icon, this.image});

  ListDataModel copyWith({
    String? title,
    String? description,
    String? icon,
    XFile? image,
  }) {
    return ListDataModel(
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
      'image': image,
    };
  }

  factory ListDataModel.fromJson(Map<String, dynamic> json) {
    return ListDataModel(
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      image: json['image'],
    );
  }

  @override
  List<Object?> get props => [title, description, icon, image];
}