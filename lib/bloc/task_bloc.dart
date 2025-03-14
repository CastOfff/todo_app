import 'package:bloc/bloc.dart';
import "package:meta/meta.dart";

import '../data/model/task.dart';
import '../data/repository/task_service.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskService taskService = TaskService();
  TaskBloc() : super(TaskInitial()) {
    on<TaskRefreshed>(_onTaskRefreshed);
    on<TaskCreated>(_onTaskCreated);
    on<TaskUpdated>(_onTaskUpdated);
    on<TaskDeleted>(_onTaskDeleted);
  }
  Future<void> _onTaskRefreshed(TaskRefreshed event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await taskService.getTasksFromServer();
      emit(TaskRefreshedSuccess(tasksFromServer: tasks));
    } catch (e) {
      emit(TaskError('Failed to refresh tasks: $e'));
    }
  }

  Future<void> _onTaskCreated(TaskCreated event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await taskService.createTask(event.task);
      final tasks = await taskService.getTasksFromServer();
      emit(TaskRefreshedSuccess(tasksFromServer: tasks));
    } catch (e) {
      emit(TaskError('Failed to create task: $e'));
    }
  }

  Future<void> _onTaskUpdated(TaskUpdated event, Emitter<TaskState> emit) async {
    try {
      await taskService.updateTask(event.task.id ?? '', event.task);
    } catch (e) {
      emit(TaskError('Failed to update task: $e'));
    }
  }

  Future<void> _onTaskDeleted(TaskDeleted event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await taskService.deleteTask(event.taskId);
      final tasks = await taskService.getTasksFromServer();
      emit(TaskRefreshedSuccess(tasksFromServer: tasks));
    } catch (e) {
      emit(TaskError('Failed to delete task: $e'));
    }
  }
}
