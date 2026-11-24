import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable()
class Todo extends Equatable {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  const Todo({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  // Create a new Todo object with selected fields changed.
  Todo copyWith({int? userId, int? id, String? title, bool? completed}) {
    return Todo(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }

  // Convert JSON received from the server into a Todo object.
  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  // Convert a Todo object into JSON.
  Map<String, dynamic> toJson() => _$TodoToJson(this);

  // Fields used by Equatable to compare two Todo objects.
  @override
  List<Object?> get props => [userId, id, title, completed];
}
