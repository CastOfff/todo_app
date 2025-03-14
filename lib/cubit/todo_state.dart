part of 'todo_cubit.dart';

@immutable
sealed class TodoState {}

final class TodoInitial extends TodoState {}

final class TodoRefreshed extends TodoState {
  final List<Task> tasksFromServer;
  TodoRefreshed({required this.tasksFromServer});
}

final class TodoLoading extends TodoState {}