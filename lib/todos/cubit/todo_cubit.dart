import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/todo.dart';
import '../todo_repository.dart';
import 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit(this._repository) : super(const TodoState());

  final TodoRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(loading: true));

    try {
      final todos = await _repository.fetchTodos();

      emit(TodoState(todos: todos));
    } catch (error) {
      emit(state.copyWith(loading: false));
      rethrow;
    }
  }

  void add(String title) {
    final normalized = title.trim();
    if (normalized.isEmpty) return;

    final todo = Todo(
      userId: 1,
      id: _nextId(),
      title: normalized,
      completed: false,
    );

    emit(state.copyWith(todos: [...state.todos, todo]));
  }

  void toggle(int id) {
    final updatedTodos = state.todos.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(completed: !todo.completed);
      }
      return todo;
    }).toList();

    emit(state.copyWith(todos: updatedTodos));
  }

  void remove(int id) {
    final updatedTodos = state.todos.where((todo) => todo.id != id).toList();

    emit(state.copyWith(todos: updatedTodos));
  }

  int _nextId() {
    if (state.todos.isEmpty) return 1;

    return state.todos.map((todo) => todo.id).reduce((a, b) => a > b ? a : b) +
        1;
  }
}
