import 'package:equatable/equatable.dart';

class ListDataModel extends Equatable {
  String? title;
  String? description;
  String? icon;

  ListDataModel({this.title, this.description, this.icon});

  ListDataModel copyWith({
    String? title,
    String? description,
    String? icon,
  }) {
    return ListDataModel(
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
    };
  }

  factory ListDataModel.fromJson(Map<String, dynamic> json) {
    return ListDataModel(
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
    );
  }

  @override
  List<Object?> get props => [title, description, icon];
}