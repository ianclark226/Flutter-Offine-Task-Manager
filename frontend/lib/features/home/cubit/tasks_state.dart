

part of 'tasks_cubit.dart';
sealed class TasksState {
  const TasksState();
}
final class TasksInitial extends TasksState{}

final class TasksLoading extends TasksState{}

final class TasksError extends TasksState{
  final String error;
  TasksError(this.error);
}

final class TasksSuccess extends TasksState{
  final TaskModel taskModel;
  TasksSuccess(this.taskModel);
}

final class GetTasksSuccess extends TasksState {
  final List<TaskModel> tasks;
  const GetTasksSuccess(this.tasks);
}