import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionName = 'todos';

  // 🔹 Todo ekle
  Future<void> addTodo(TodoModel todo) async {
    await _db.collection(collectionName).add(todo.toMap());
  }

  // 🔹 Todo güncelle (tamamlandı / tamamlanmadı)
  Future<void> updateTodoStatus(String id, bool isDone) async {
    await _db.collection(collectionName).doc(id).update({'isDone': isDone});
  }

  // 🔹 Gerçek zamanlı tüm todo'ları getir
  Stream<List<TodoModel>> getTodosStream() {
  return _db            
        .collection(collectionName)
        .orderBy('date') // tarihi göre sıralı
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TodoModel.fromMap(doc.data(), doc.id))
            .toList());
  }


  Future<void> deleteTodo(String id) async {
    await _db.collection(collectionName).doc(id).delete();
  }
}
