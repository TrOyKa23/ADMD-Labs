import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/todo.dart';
import '../todo_repository.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc(this._repository) : super(const TodoState()) {
    on<LoadTodos>(_onLoad);
    on<AddTodo>(_onAdd);
    on<ToggleTodo>(_onToggle);
    on<RemoveTodo>(_onRemove);
  }

  final TodoRepository _repository;

  Future<void> _onLoad(LoadTodos event, Emitter<TodoState> emit) async {
    emit(state.copyWith(loading: true));

    try {
      final todos = await _repository.fetchTodos();
      emit(TodoState(todos: todos));
    } catch (_) {
      emit(state.copyWith(loading: false));
    }
  }

  void _onAdd(AddTodo event, Emitter<TodoState> emit) {
    final title = event.title.trim();
    if (title.isEmpty) return;

    final nextId = state.todos.isEmpty
        ? 1
        : state.todos.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;

    final todo = Todo(userId: 1, id: nextId, title: title, completed: false);

    emit(state.copyWith(todos: [...state.todos, todo]));
  }

  void _onToggle(ToggleTodo event, Emitter<TodoState> emit) {
    final updated = state.todos.map((todo) {
      if (todo.id == event.id) {
        return todo.copyWith(completed: !todo.completed);
      }
      return todo;
    }).toList();

    emit(state.copyWith(todos: updated));
  }

  void _onRemove(RemoveTodo event, Emitter<TodoState> emit) {
    final updated = state.todos.where((todo) => todo.id != event.id).toList();

    emit(state.copyWith(todos: updated));
  }
}
