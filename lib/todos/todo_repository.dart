import 'package:dio/dio.dart';

import '../models/todo.dart';

class TodoRepository {
  TodoRepository(this._dio);

  final Dio _dio;

  static const String _url = 'https://jsonplaceholder.typicode.com/todos';

  Future<List<Todo>> fetchTodos() async {
    final response = await _dio.get(_url);

    return (response.data as List).map((json) => Todo.fromJson(json)).toList();
  }
}
