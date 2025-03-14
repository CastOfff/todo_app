
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/task.dart';

class TaskService{
  static const domain = '67caf9da3395520e6af3dbc6.mockapi.io';
  static const header = {
    'Content-Type': 'application/json',
  };

  Future<List<Task>> getTasksFromServer() async {
    try {
      final response = await http.get(Uri.https(domain, 'users'), headers: header);
      if (response.statusCode == 200) {
        final List<dynamic> listJson = jsonDecode(response.body);
        return listJson.map((e) => Task.fromJson(e)).toList();
    } else {
        throw Exception('Lỗi khi tải trang: ${response.statusCode}');
      }
    } catch (e) {
        print('Lỗi kết nối API: $e');
        return [];
      }
  }

  Future<Task> createTask(Task task) async {
    final response = await http.post(
      Uri.https(domain, 'users'),
      headers: header,
      body: jsonEncode(task.toJson()),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return Task.fromJson(data);
  }

  Future<Task> updateTask(String id, Task task) async {
    final response = await http.put(
      Uri.https(domain, 'users/$id'),
      headers: header,
      body: jsonEncode(task.toJson()),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return Task.fromJson(data);
  }

  Future<void> deleteTask(String id) async {
    final response = await http.delete(
      Uri.https(domain, 'users/$id'),
      headers: header,
    );
    if (response.statusCode != 200) {
      throw Exception('Lỗi khi xóa sản phẩm: ${response.statusCode}');
    }
  }
}