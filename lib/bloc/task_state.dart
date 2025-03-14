part of 'task_bloc.dart';

@immutable
sealed class TaskState {}

final class TaskInitial extends TaskState {}

final class TaskRefreshedSuccess extends TaskState {
  final List<Task> tasksFromServer;

  TaskRefreshedSuccess({required this.tasksFromServer});
}

final class TaskLoading extends TaskState {}

final class TaskLoadFailure extends TaskState {}

class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
}