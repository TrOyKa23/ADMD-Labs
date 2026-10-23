import 'package:flutter/material.dart';

class Todo {
  Todo(this.title)
    : id = DateTime.now().microsecondsSinceEpoch,
      done = ValueNotifier<bool>(false);

  final int id;
  final String title;
  final ValueNotifier<bool> done;

  void dispose() {
    done.dispose();
  }
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoState();
}

class _TodoState extends State<TodoScreen> {
  final List<Todo> _items = [];
  final TextEditingController _input = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _add() {
    final title = _input.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title.')),
      );
      return;
    }

    setState(() {
      _items.add(Todo(title));
    });

    _input.clear();

    // Scroll to the newly added task after the list rebuilds.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _remove(Todo todo) {
    final index = _items.indexWhere((item) => item.id == todo.id);

    if (index == -1) return;

    setState(() {
      _items.removeWhere((item) => item.id == todo.id);
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('"${todo.title}" deleted'),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              if (!mounted) return;

              setState(() {
                final safeIndex = index.clamp(0, _items.length);
                _items.insert(safeIndex, todo);
              });
            },
          ),
          duration: const Duration(seconds: 4),
        ),
      );
  }

  int get _completedCount {
    var count = 0;

    for (var i = 0; i < _items.length; i++) {
      count += _items[i].done.value ? 1 : 0;
    }

    return count;
  }

  @override
  void dispose() {
    _input.dispose();
    _scrollController.dispose();

    for (final todo in _items) {
      todo.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 3 — To-do List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _input,
              decoration: InputDecoration(
                labelText: 'New task',
                hintText: 'Enter a task...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: _add,
                  tooltip: 'Add task',
                  icon: const Icon(Icons.add),
                ),
              ),
              onSubmitted: (_) => _add(),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Completed: $_completedCount / ${_items.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _items.isEmpty
                  ? const Center(
                      child: Text('No tasks yet. Add your first task above!'),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final todo = _items[index];

                        return Dismissible(
                          key: ValueKey(todo.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (_) => _remove(todo),
                          child: TodoTile(todo: todo),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoTile extends StatelessWidget {
  const TodoTile({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ValueListenableBuilder<bool>(
        valueListenable: todo.done,
        builder: (context, isDone, child) {
          return CheckboxListTile(
            value: isDone,
            onChanged: (value) {
              todo.done.value = value ?? false;
            },
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: isDone ? Colors.grey : null,
              ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
          );
        },
      ),
    );
  }
}
