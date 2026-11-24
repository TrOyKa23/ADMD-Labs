import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'todos/todo_repository.dart';
import 'todos/bloc/todo_bloc.dart';
import 'todos/bloc/todo_event.dart';
import 'screens/todo_screen.dart';

void main() {
  final repository = TodoRepository(Dio());

  runApp(
    BlocProvider(
      create: (_) => TodoBloc(repository)..add(LoadTodos()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADMD Lab 5',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TodoScreen(),
    );
  }
}
