import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../todos/bloc/todo_bloc.dart';
import '../todos/bloc/todo_event.dart';
import '../todos/bloc/todo_state.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ADMD Lab 5 — BLoC'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final completed = state.todos.where((todo) => todo.completed).length;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text('$completed / ${state.todos.length} completed'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: 'Enter a new task',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (value) {
                          context.read<TodoBloc>().add(AddTodo(value));
                          controller.clear();
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        context.read<TodoBloc>().add(AddTodo(controller.text));
                        controller.clear();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.todos.length,
                  itemBuilder: (context, index) {
                    final todo = state.todos[index];

                    return Dismissible(
                      key: ValueKey(todo.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) {
                        context.read<TodoBloc>().add(RemoveTodo(todo.id));
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: CheckboxListTile(
                        value: todo.completed,
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Text(
                          'Task ID: ${todo.id} · User ID: ${todo.userId}',
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (_) {
                          context.read<TodoBloc>().add(ToggleTodo(todo.id));
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
