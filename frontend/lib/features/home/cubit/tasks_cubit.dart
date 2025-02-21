import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/home/repo/task_remote_repo.dart';
import 'package:frontend/models/task_model.dart';


part 'tasks_state.dart';
@Deprecated('Use .r.')
class TasksCubit  extends Cubit<TasksState>{
  TasksCubit() : super(TasksInitial());
  final taskRemoteRepo = TaskRemoteRepo();
  Future<void> createNewTask({
    required String title,
    required String description,
    required Color color,
    required String token,
    required DateTime dueAt,
  }) async {
    try {
      emit(TasksLoading());
      final taskModel = await taskRemoteRepo.createTask(title: title, description: description, hexColor: rgbToHex(color), token: token, dueAt: dueAt);

      emit(TasksSuccess(taskModel));
    } catch(error) {
      emit(TasksError(error.toString()));
    }
  }

  Future<void> getAllTasks({
    required String token,
    
  }) async {
    try {
      emit(TasksLoading());
      final tasks = await taskRemoteRepo.getTasks(token: token);

      emit(GetTasksSuccess(tasks));
    } catch(error) {
      emit(TasksError(error.toString()));
    }
  }
}