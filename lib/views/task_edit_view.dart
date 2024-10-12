import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/task_viewmodel.dart';
import '../models/task.dart';

class TaskEditView extends StatefulWidget {
  final Task? task;

  TaskEditView({this.task});

  @override
  _TaskEditViewState createState() => _TaskEditViewState();
}

class _TaskEditViewState extends State<TaskEditView> {
  final TaskViewModel taskViewModel = Get.find();
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  late int priority;
  late DateTime dueDate;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      title = widget.task!.title;
      description = widget.task!.description;
      priority = widget.task!.priority;
      dueDate = widget.task!.dueDate;
    } else {
      title = '';
      description = '';
      priority = 1; //Priority is always set low
      dueDate = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.teal),
        title: Text(
          widget.task != null ? 'Edit Task' : 'New Task',
          style: TextStyle(color: Colors.teal),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.teal),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: TextStyle(color: Colors.black),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title.';
                  }
                  return null;
                },
                onChanged: (value) {
                  title = value;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.teal),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: TextStyle(color: Colors.black),
                onChanged: (value) {
                  description = value;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: priority,
                decoration: InputDecoration(
                  labelText: 'Priority',
                  labelStyle: TextStyle(color: Colors.teal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(Icons.low_priority, color: Colors.teal),
                        SizedBox(width: 8),
                        Text('Low'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(Icons.priority_high, color: Colors.teal),
                        SizedBox(width: 8),
                        Text('Medium'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.teal),
                        SizedBox(width: 8),
                        Text('High'),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  priority = value!;
                },
                dropdownColor: Colors.white,
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      dueDate = pickedDate;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Due Date',
                    labelStyle: TextStyle(color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                  child: Text(
                    '${dueDate.toLocal()}'.split(' ')[0],
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.task != null) {
                        // Update existing task
                        taskViewModel.updateTask(Task(
                          id: widget.task!.id,
                          title: title,
                          description: description,
                          priority: priority,
                          dueDate: dueDate,
                        ));
                      } else {
                        // Create new task
                        taskViewModel.addTask(Task(
                          title: title,
                          description: description,
                          priority: priority,
                          dueDate: dueDate,
                        ));
                      }
                      Get.back();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    widget.task != null ? 'Update Task' : 'Create Task',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
