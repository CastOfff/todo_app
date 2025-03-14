part of 'task_bloc.dart';

@immutable
sealed class TaskEvent {}

class TaskRefreshed extends TaskEvent{}

class TaskCreated extends TaskEvent {
  final Task task;
  TaskCreated(this.task);
}

class TaskUpdated extends TaskEvent {
  final Task task;
  TaskUpdated(this.task);
}

class TaskDeleted extends TaskEvent {
  final String taskId;
  TaskDeleted(this.taskId);
}