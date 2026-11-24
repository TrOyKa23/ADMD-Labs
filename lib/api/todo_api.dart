import 'dart:math';

import 'package:dio/dio.dart';

import '../models/todo.dart';

class TodoApi {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  final void Function(String message) onLog;

  TodoApi({required this.onLog});

  // Execute an operation again if it fails.
  Future<T> withRetry<T>(Future<T> Function() operation) async {
    const maxAttempts = 5;

    for (var i = 0; i < maxAttempts; i++) {
      final attempt = i + 1;

      onLog('Attempt $attempt/$maxAttempts');

      try {
        final result = await operation();

        onLog('Attempt $attempt: SUCCESS');

        return result;
      } catch (error) {
        if (i == maxAttempts - 1) {
          onLog('Attempt $attempt: FAILED. No attempts left.');
          rethrow;
        }

        // Exponential backoff.
        final baseDelay = 400 * (1 << i);

        // Add random jitter.
        final jitter = Random().nextInt(baseDelay);

        final delay = baseDelay + jitter;

        onLog(
          'Attempt $attempt: FAILED. '
          'Retrying in $delay ms. Error: $error',
        );

        await Future.delayed(Duration(milliseconds: delay));
      }
    }

    throw StateError('Unexpected retry state');
  }

  // Load all todos from the API.
  Future<List<Todo>> fetchTodos() {
    return withRetry(() async {
      final response = await _dio.get('/todos');

      final raw = response.data as List<dynamic>;

      return raw
          .map((json) => Todo.fromJson(json as Map<String, dynamic>))
          .toList();
    });
  }

  // Intentionally use an invalid path to demonstrate retry.
  Future<void> testInvalidPath() async {
    try {
      await withRetry(() async {
        await _dio.get('/nope');
      });
    } catch (error) {
      onLog('Invalid path test finished: $error');
    }
  }
}
