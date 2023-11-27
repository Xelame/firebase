import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import 'database.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescriptionController = TextEditingController();

  void _addTaskToList() {
    String taskTitle = _taskTitleController.text;
    String taskDescription = _taskDescriptionController.text;
    if (taskTitle.isNotEmpty) {
      if (taskDescription.isEmpty) {
        taskDescription = 'No description';
      } 

      DatabaseHelper.instance.insert(Todo(taskTitle: taskTitle,taskDescription: taskDescription,isCompleted: 0));
      _taskTitleController.clear();
      Navigator.pop(context); // Revenir à l'écran principal
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task title cannot be empty'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(height: 20);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add Task'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _taskTitleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
              ),
              spacer,

              SizedBox(
                child : TextFormField(
                  controller: _taskDescriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  maxLines: 2,
                ),
              ),
              spacer,
              ElevatedButton(
                onPressed: () {
                  _addTaskToList();
                },
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
