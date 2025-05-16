import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String? id;
  String title;
  String subtitle;
  DateTime date;
  String iconName;
  bool isDone;

  TodoModel({
    this.id, 
    required this.title,
    required this.subtitle,
    required this.date,
    required this.iconName,
    required this.isDone,
  });

  // Firestore'dan veri almak için
  factory TodoModel.fromMap(Map<String, dynamic> data, String docId) {
    return TodoModel(
      id: docId,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      iconName: data['iconName'] ?? '',
      isDone: data['isDone'] ?? false,
    );
  }

  // Firestore'a veri göndermek için
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'date': date,
      'iconName': iconName,
      'isDone': isDone,
    };
  }
}
