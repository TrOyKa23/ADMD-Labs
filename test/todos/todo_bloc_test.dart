import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lab1_app/models/todo.dart';
import 'package:lab1_app/todos/todo_repository.dart';
import 'package:lab1_app/todos/bloc/todo_bloc.dart';
import 'package:lab1_app/todos/bloc/todo_event.dart';
import 'package:lab1_app/todos/bloc/todo_state.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late MockTodoRepository repository;

  setUp(() {
    repository = MockTodoRepository();
  });

  blocTest<TodoBloc, TodoState>(
    'add then toggle emits two states in order',
    build: () => TodoBloc(repository),
    act: (bloc) => bloc
      ..add(AddTodo('Milk'))
      ..add(ToggleTodo(1)),
    expect: () => [
      TodoState(
        todos: [const Todo(userId: 1, id: 1, title: 'Milk', completed: false)],
      ),
      TodoState(
        todos: [const Todo(userId: 1, id: 1, title: 'Milk', completed: true)],
      ),
    ],
  );
}
