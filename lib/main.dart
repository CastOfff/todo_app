import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/task_bloc.dart';
import 'data/model/task.dart';
import 'data/repository/task_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskBloc>(
      create: (context) => TaskBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final taskService = TaskService();

  @override
  void initState() {
    context.read<TaskBloc>().add(TaskRefreshed());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('to do'),
          actions: [
            IconButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      String taskName = '';
                      return AlertDialog(
                        title: Text('Create new Task'),
                        content: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter task name',
                          ),
                          onChanged: (value) {
                            taskName = value;
                          },
                        ),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                context.read<TaskBloc>().add(TaskCreated(Task(name: taskName)));
                              },
                              child: Text('Save')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'))
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.add)),

            IconButton(
                onPressed: () async {
                  context.read<TaskBloc>().add(TaskRefreshed());
                },
                icon: Icon(Icons.refresh))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  final isLoading = state is TaskLoading;
                  if (isLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if(state is TaskRefreshedSuccess) {
                    return _buildListTaskView(context, state.tasksFromServer);
                  } else {
                    return Center(child: Text('Click to Reload'));
                  }
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTaskView(BuildContext context, List<Task> tasks) {
    tasks = tasks.reversed.toList();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 10,
            children: [
              Checkbox(
                value: tasks[index].isCompleted,
                onChanged: (value) async {
                  tasks[index].isCompleted =
                      !(tasks[index].isCompleted ?? false);
                  context.read<TaskBloc>().add(TaskUpdated(tasks[index]));
                setState(() {

                });
                },
              ),
              Text(tasks[index].name ?? ''),
              Spacer(),
              IconButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('DeleteTask'),
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  context.read<TaskBloc>().add(TaskDeleted(tasks[index].id ?? ''));
                                },
                                child: Text('Delete')),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'))
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ))
            ],
          ),
        );
      },
    );
  }
}
