import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  final List<TaskModel> _tasks = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoader(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchTasks() async {
    try {
      _setLoader(true);
      http.Response response = await http.get(Uri.parse(baseUrl));
      List<dynamic> listTasks = jsonDecode(response.body);
      Iterable<TaskModel> serializedTask = listTasks.map((dynamic element) =>
          TaskModel.fromMap(element as Map<String, dynamic>));
      _tasks.clear();
      _tasks.addAll(serializedTask);
      notifyListeners();
      print(response);
    } catch (e) {
      print(e);
    } finally {
      _setLoader(false);
    }
  }

  List<TaskModel> getTasks({
    bool? isCompleted,
    required OrderBy orderBy,
  }) {
    final List<TaskModel> tasksList = [];
    if (isCompleted == true) {
      tasksList.addAll(_tasks.where((TaskModel task) => task.isCompleted));
    } else if (isCompleted == false) {
      tasksList.addAll(_tasks.where((TaskModel task) => !task.isCompleted));
    } else {
      tasksList.addAll(_tasks);
    }

    // Apply Sorting
    if (orderBy == OrderBy.ascending) {
      tasksList.sort((a, b) => a.dueDate != null && b.dueDate != null
          ? a.dueDate!.compareTo(b.dueDate!)
          : 0);
    } else if (orderBy == OrderBy.descending) {
      tasksList.sort((a, b) => a.dueDate != null && b.dueDate != null
          ? b.dueDate!.compareTo(a.dueDate!)
          : 0);
    }

    return tasksList;
  }

  Future<void> addTask(
      {required String title,
      required String description,
      required DateTime? dueDate}) async {
    final TaskModel task = TaskModel(
        id: _tasks.length,
        title: title,
        description: description,
        dueDate: dueDate);
    try {
      _setLoader(true);
      http.Response response = await http.post(Uri.parse(baseUrl), body: {
        "title": title,
        "description": description,
        "dueDate": dueDate?.toIso8601String(),
      });
      dynamic decodedResponse = jsonDecode(response.body);
      final TaskModel task = TaskModel.fromMap(decodedResponse);
      _tasks.add(task);
      print(task);
      notifyListeners();
      print(response);
    } catch (e) {
      print(e);
    } finally {
      _setLoader(false);
    }
  }

  Future<void> deleteTask(int id) async {
    final TaskModel task = _tasks.firstWhere((element) => element.id == id);
    final int indexOfTask = _tasks.indexOf(task);
    try {
      _tasks.remove(task);
      _setLoader(true);
      final Uri deleteUrl = Uri.parse('$baseUrl/$id');
      // http.Response response =
      await http.delete(deleteUrl);

      // final TaskModel note = TaskModel.fromMap(jsonDecode(response.body));

    } catch (e) {
      print(e);
      _tasks.insert(indexOfTask, task);
    } finally {
      _setLoader(false);
    }
  }

  void toggleCompletionOfTask({required int id, required bool isCompleted}) {
    final TaskModel task =
        _tasks.firstWhere((TaskModel taskElement) => taskElement.id == id);
    task.isCompleted = isCompleted;
    int index =
        _tasks.indexWhere((TaskModel taskElement) => taskElement.id == id);
    _tasks[index] = task;
    notifyListeners();
  }

  void updateTask({ required id, required String title,
      required String description,
      required DateTime? dueDate}) async {
    try {
      _setLoader(true);
      http.Response response =
      await http.put(Uri.parse('$baseUrl/$id'), body: {
        "title": title,
        "description": description,
        "dueDate": dueDate?.toIso8601String(),
      });
      final TaskModel updatedTask = TaskModel.fromMap(
        jsonDecode(response.body),
      );

      int index = _tasks.indexWhere((task) => task.id == id);
      _tasks[index] = updatedTask;
      notifyListeners();
      print(response);
    } catch (e) {
      print(e);
    } finally {
      _setLoader(false);
    }
  }
}

enum OrderBy {
  all,
  ascending,
  descending,
}
