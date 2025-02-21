import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/home/repo/task_local_repo.dart';
import 'package:frontend/models/task_model.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class TaskRemoteRepo {
  final taskLocalRepo = TaskLocalRepo();
  Future<TaskModel> createTask({
    required String title,
    required String description,
    required String hexColor,
    required String token,
    required String uid,
    required DateTime dueAt,
  }) async {
    try {
    final res = await http.post(Uri.parse("${Constants.backendUri}/tasks"),
    headers: {
      'Content-Type': 'application/json',
      'x-auth-token': token,
    },
    body: jsonEncode({
      'title': title,
      'description': description,
      'hexColor': hexColor,
      'dueAt': dueAt.toIso8601String(),
    })
    );

    if(res.statusCode != 201) {
      throw jsonDecode(res.body)['error'];
    }

    return TaskModel.fromJson(res.body);
    
    } catch(error) {
      try {final taskModel = TaskModel(id: const Uuid().v4(), uid: uid, title: title, description: description, createdAt: DateTime.now(), updatedAt: DateTime.now(), dueAt: dueAt, color: hexToRgb(hexColor), isSynced: 0);
      await taskLocalRepo.insertTask(taskModel);
      return taskModel;
      } catch(error) {
      
      rethrow;
      }
    }
  }

  Future<List<TaskModel>> getTasks({
    required String token,
  }) async {
    try {
    final res = await http.get(Uri.parse("${Constants.backendUri}/tasks"),
    headers: {
      'Content-Type': 'application/json',
      'x-auth-token': token,
    },
 
    );

    if(res.statusCode != 200) {
      throw jsonDecode(res.body)['error'];
    }

    final listOfTasks = jsonDecode(res.body);
    List<TaskModel> tasksList = [];

    for(var elem in listOfTasks) {
      tasksList.add(TaskModel.fromMap(elem));
    }

    await taskLocalRepo.insertTasks(tasksList);

    return tasksList;
    } catch(error) {
      final tasks = await taskLocalRepo.getTask();
      if(tasks.isNotEmpty) {
        return tasks;
      }
      rethrow;
    }
  }

  Future<bool> syncTasks({
    required String token,
    required List<TaskModel> tasks,
  }) async {
    try {
      final taskListInMap = [];
      for(final task in tasks) {
        taskListInMap.add(task.toMap());
      }
    final res = await http.post(Uri.parse("${Constants.backendUri}/tasks/sync"),
    headers: {
      'Content-Type': 'application/json',
      'x-auth-token': token,
    },
    body: jsonEncode(taskListInMap)
    );

    if(res.statusCode != 201) {
      throw jsonDecode(res.body)['error'];
    }

    return true;
    
    } catch(error) {
      return false;
    }
  }
}