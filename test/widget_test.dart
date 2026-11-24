import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lab1_app/models/todo.dart';
import 'package:lab1_app/screens/todo_screen.dart';
import 'package:lab1_app/todos/todo_repository.dart';
import 'package:lab1_app/todos/bloc/todo_bloc.dart';

class FakeTodoRepository implements TodoRepository {
  @override
  Future<List<Todo>> fetchTodos() async {
    return [
      const Todo(userId: 1, id: 1, title: 'Learn Flutter', completed: false),
    ];
  }
}

void main() {
  testWidgets('TodoScreen displays todos', (WidgetTester tester) async {
    final repository = FakeTodoRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => TodoBloc(repository),
          child: const TodoScreen(),
        ),
      ),
    );

    expect(find.text('0 / 0 completed'), findsOneWidget);
  });
}
