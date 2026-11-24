import 'package:flutter/material.dart';

import '../api/todo_api.dart';
import '../models/todo.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late final TodoApi _api;

  List<Todo> _items = [];
  final Set<int> _completedIds = {};

  final List<String> _logs = [];

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();

    _api = TodoApi(onLog: _addLog);

    _testEquality();

    _loadTodos();
  }

  void _addLog(String message) {
    if (!mounted) return;

    setState(() {
      _logs.add(
        '${DateTime.now().toLocal().toString().substring(11, 19)}  $message',
      );

      // Keep only the latest 30 log entries.
      if (_logs.length > 30) {
        _logs.removeAt(0);
      }
    });
  }

  // Task 1 — Test Equatable
  void _testEquality() {
    const a = Todo(userId: 1, id: 10, title: 'Learn Flutter', completed: false);

    const b = Todo(userId: 1, id: 10, title: 'Learn Flutter', completed: false);

    debugPrint('Task 1 — Are a and b equal? ${a == b}');
  }

  Future<void> _loadTodos() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final todos = await _api.fetchTodos();

      if (!mounted) return;

      setState(() {
        _items = todos;

        _completedIds
          ..clear()
          ..addAll(
            todos.where((todo) => todo.completed).map((todo) => todo.id),
          );

        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _testRetry() async {
    await _api.testInvalidPath();
  }

  void _toggleTodo(Todo todo, bool value) {
    setState(() {
      if (value) {
        _completedIds.add(todo.id);
      } else {
        _completedIds.remove(todo.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _completedIds.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ADMD Lab 4 — Networking'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _loadTodos,
            tooltip: 'Reload todos',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Todos from JSONPlaceholder',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text('$completedCount / ${_items.length} completed'),
              ],
            ),
          ),

          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_error != null)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 12),
                      const Text('Could not load todos'),
                      const SizedBox(height: 8),
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _loadTodos,
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final todo = _items[index];

                  return TodoTile(
                    todo: todo,
                    completed: _completedIds.contains(todo.id),
                    onChanged: (value) {
                      _toggleTodo(todo, value);
                    },
                  );
                },
              ),
            ),

          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Retry demonstration',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _testRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Test /nope'),
                ),
              ],
            ),
          ),

          Container(
            height: 180,
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.terminal, size: 18),
                    const SizedBox(width: 8),
                    const Text(
                      'Retry log',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _logs.clear();
                        });
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
                const Divider(height: 1),
                Expanded(
                  child: _logs.isEmpty
                      ? const Center(child: Text('No requests yet'))
                      : ListView.builder(
                          itemCount: _logs.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                _logs[index],
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 11,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TodoTile extends StatelessWidget {
  const TodoTile({
    super.key,
    required this.todo,
    required this.completed,
    required this.onChanged,
  });

  final Todo todo;
  final bool completed;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: CheckboxListTile(
        value: completed,
        onChanged: (value) {
          onChanged(value ?? false);
        },
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: completed
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Text('Task ID: ${todo.id} · User ID: ${todo.userId}'),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}
