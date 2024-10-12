import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/task_viewmodel.dart';
import 'task_edit_view.dart';
import '../models/task.dart';

class TaskListView extends StatelessWidget {
  final TaskViewModel taskViewModel = Get.put(TaskViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Tasks',
          style: TextStyle(
            color: Colors.teal,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.sort, color: Colors.teal),
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(1000, 80, 0, 0),
                items: [
                  PopupMenuItem<String>(
                    value: 'Due Date',
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.teal),
                        SizedBox(width: 10),
                        Text('Due Date', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'Priority',
                    child: Row(
                      children: [
                        Icon(Icons.priority_high, color: Colors.teal),
                        SizedBox(width: 10),
                        Text('Priority', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ],
                color: Colors.white,
              ).then((value) {
                if (value != null) {
                  taskViewModel.setSorting(value);
                }
              });
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                onChanged: (value) {
                  taskViewModel.searchTasks(value);
                },
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Search tasks...',
                  hintStyle: TextStyle(color: Colors.teal.shade200),
                  prefixIcon: Icon(Icons.search, color: Colors.teal),
                  filled: true,
                  fillColor: Colors.teal.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),

            // Task List
            Expanded(
              child: Obx(() {
                var tasks = taskViewModel.filteredTasks.isEmpty
                    ? taskViewModel.tasks
                    : taskViewModel.filteredTasks;

                if (tasks.isEmpty) {
                  return Center(
                    child: Text(
                      'No tasks available.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    Task task = tasks[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: GestureDetector(
                        onTap: () {
                          // Tap to edit
                          Get.to(() => TaskEditView(task: task));
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.teal.shade100),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title,
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      _getPriorityLabel(task
                                          .priority), // Converts priority value to a readable label
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.teal),
                                onPressed: () {
                                  // Delete
                                  taskViewModel.deleteTask(task.id!);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(TaskEditView());
        },
        backgroundColor: Colors.teal,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

String _getPriorityLabel(int priority) {
  switch (priority) {
    case 1:
      return 'High';
    case 2:
      return 'Medium';
    case 3:
      return 'Low';
    default:
      return 'Unknown';
  }
}

class TaskSearch extends SearchDelegate<String> {
  final TaskViewModel taskViewModel;

  TaskSearch(this.taskViewModel);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    taskViewModel.searchTasks(query);
    return Obx(() {
      if (taskViewModel.tasks.isEmpty) {
        return Center(child: Text('No tasks found.'));
      }
      return ListView.builder(
        itemCount: taskViewModel.tasks.length,
        itemBuilder: (context, index) {
          Task task = taskViewModel.tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text('${task.description}\nDue: ${task.dueDate}'),
            isThreeLine: true,
            onTap: () {
              close(context, '');
              Get.to(TaskEditView(task: task));
            },
          );
        },
      );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Obx(() {
      final suggestions = taskViewModel.tasks.where((task) {
        return task.title.toLowerCase().contains(query.toLowerCase());
      }).toList();

      if (suggestions.isEmpty) {
        return Center(child: Text('No suggestions found.'));
      }

      return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          Task task = suggestions[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text('${task.description}\nDue: ${task.dueDate}'),
            isThreeLine: true,
            onTap: () {
              close(context, '');
              Get.to(TaskEditView(task: task));
            },
          );
        },
      );
    });
  }
}
