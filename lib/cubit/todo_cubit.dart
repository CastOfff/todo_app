import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../data/model/task.dart';
import '../data/repository/task_service.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final TaskService taskService = TaskService();
  TodoCubit() : super(TodoInitial());

  void refreshTodo() async{
    emit(TodoLoading());
    List<Task> tasks = await taskService.getTasksFromServer();
    emit(TodoRefreshed(tasksFromServer: tasks));
  }

  void createTask(Task task) async {
    emit(TodoLoading());
    await taskService.createTask(task);
    refreshTodo();
  }

  void updateTask(Task task) async {
    emit(TodoLoading());
    await taskService.updateTask(task.id ?? '', task);
    refreshTodo();
  }

  void deleteTask(String taskId) async {
    emit(TodoLoading());
    await taskService.deleteTask(taskId);
    refreshTodo();
  }
}
