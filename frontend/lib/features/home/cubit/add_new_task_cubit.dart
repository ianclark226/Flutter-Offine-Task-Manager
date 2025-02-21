import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/home/repo/task_remote_repo.dart';
import 'package:frontend/models/task_model.dart';


part 'add_new_task_state.dart';
@Deprecated('Use .r.')
class AddNewTaskCubit  extends Cubit<AddNewTaskState>{
  AddNewTaskCubit() : super(AddNewTaskInitial());
  final taskRemoteRepo = TaskRemoteRepo();
  Future<void> createNewTask({
    required String title,
    required String description,
    required Color color,
    required String token,
    required DateTime dueAt,
  }) async {
    try {
      emit(AddNewTaskLoading());
      final taskModel = await taskRemoteRepo.createTask(title: title, description: description, hexColor: rgbToHex(color), token: token, dueAt: dueAt);

      emit(AddNewTaskSuccess(taskModel));
    } catch(error) {
      emit(AddNewTaskError(error.toString()));
    }
  }
}