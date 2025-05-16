import 'package:flutter/material.dart';
import '../models/todo_model.dart';

class TodoTile extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback onChanged;
  final VoidCallback onDelete; 

  const TodoTile({
    Key? key,
    required this.todo,
    required this.onChanged,
    required this.onDelete, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconData = _getIconFromName(todo.iconName);

    return ListTile(
      leading: Icon(iconData),
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(todo.subtitle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: todo.isDone,
            onChanged: (_) => onChanged(),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  IconData _getIconFromName(String name) {
    const iconMap = {
      'work': Icons.work,
      'home': Icons.home,
      'school': Icons.school,
      'fitness': Icons.fitness_center,
      'music': Icons.music_note,
      'shopping': Icons.shopping_cart,
      'travel': Icons.flight,
      'book': Icons.book,
      'meeting': Icons.meeting_room,
      'other': Icons.more_horiz,
    };

    return iconMap[name] ?? Icons.help_outline;
  }
}
