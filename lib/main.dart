import 'widgets/add_todo_sheet.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/todo_model.dart';
import 'services/firestore_service.dart';
import 'widgets/todo_tile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Final Todo App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final _firestoreService = FirestoreService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Görev Listesi"),
      ),
      body: StreamBuilder<List<TodoModel>>(
        stream: _firestoreService.getTodosStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Henüz görev eklenmedi."));
          }

          final todos = snapshot.data!;

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoTile(
              todo: todo,
              onChanged: () {
                _firestoreService.updateTodoStatus(todo.id!, !todo.isDone);
              },
              onDelete: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Silinsin mi?"),
                content: const Text("Bu görevi silmek istediğinize emin misiniz?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text("İptal"),
                  ),
                  TextButton(
                    onPressed: () {
                      _firestoreService.deleteTodo(todo.id!);
                      Navigator.pop(ctx);
                    },
                    child: const Text("Sil", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },

            );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: const AddTodoSheet(),
            ),
          );

        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
