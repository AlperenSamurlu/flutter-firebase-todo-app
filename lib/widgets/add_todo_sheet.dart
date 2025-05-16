import 'add_todo_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import '../services/firestore_service.dart';

class AddTodoSheet extends StatefulWidget {
  const AddTodoSheet({super.key});

  @override
  State<AddTodoSheet> createState() => _AddTodoSheetState();
}

class _AddTodoSheetState extends State<AddTodoSheet> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  String? _selectedIcon;
  DateTime? _selectedDate;

  final List<Map<String, dynamic>> _iconList = [
    {'label': 'Work', 'icon': Icons.work, 'value': 'work'},
    {'label': 'Home', 'icon': Icons.home, 'value': 'home'},
    {'label': 'School', 'icon': Icons.school, 'value': 'school'},
    {'label': 'Fitness', 'icon': Icons.fitness_center, 'value': 'fitness'},
    {'label': 'Music', 'icon': Icons.music_note, 'value': 'music'},
    {'label': 'Shopping', 'icon': Icons.shopping_cart, 'value': 'shopping'},
    {'label': 'Travel', 'icon': Icons.flight, 'value': 'travel'},
    {'label': 'Book', 'icon': Icons.book, 'value': 'book'},
    {'label': 'Meeting', 'icon': Icons.meeting_room, 'value': 'meeting'},
    {'label': 'Other', 'icon': Icons.more_horiz, 'value': 'other'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedIcon,
              items: _iconList.map((item) {
                return DropdownMenuItem<String>(
                  value: item['value'],
                  child: Row(
                    children: [
                      Icon(item['icon']),
                      const SizedBox(width: 8),
                      Text(item['label']),
                    ],
                  ),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'İkon Seç'),
              onChanged: (value) => setState(() => _selectedIcon = value),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Başlık'),
            ),
            TextField(
              controller: _subtitleController,
              decoration: const InputDecoration(labelText: 'Alt Başlık'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  _selectedDate == null
                      ? 'Tarih seçilmedi'
                      : 'Seçilen: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                ),
                const Spacer(),
                TextButton(
                  child: const Text("Tarih Seç"),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                )
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isEmpty ||
                    _subtitleController.text.isEmpty ||
                    _selectedDate == null ||
                    _selectedIcon == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Tüm alanları doldurun")),
                  );
                  return;
                }

                final newTodo = TodoModel(
                  title: _titleController.text,
                  subtitle: _subtitleController.text,
                  iconName: _selectedIcon!,
                  date: _selectedDate!,
                  isDone: false,
                );

                await FirestoreService().addTodo(newTodo);
                Navigator.pop(context); // modalı kapat
              },
              child: const Text("Ekle"),
            )
          ],
        ),
      ),
    );
  }
}
