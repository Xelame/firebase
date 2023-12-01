import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final notes = FirebaseFirestore.instance.collection('notes');

  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();

  PlatformFile? _file;
  UploadTask? _task;
  String _urlDownload = '';

  Future _selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _file = result.files.first;
      });
    }
  }

  Future _uploadFile() async {
    final path = 'file/${_file!.name}';
    final file = File(_file!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      _task = ref.putFile(file);
    });

    await _task!.whenComplete(() async {
      _urlDownload = await ref.getDownloadURL();
    });

    print('Download-Link: $_urlDownload');

    setState(() {
      _task = null;
    });
  }

  void _addTaskToList() async {
    String taskTitle = _taskTitleController.text;
    String taskDescription = _taskDescriptionController.text;
    if (taskTitle.isNotEmpty) {
      if (taskDescription.isEmpty) {
        taskDescription = 'No description';
      }

      if (_file != null) {
        await _uploadFile();

        notes.add({
          'title': taskTitle,
          'content': taskDescription,
          'done': false,
          'file': 'file/${_file!.name}',
        });
      } else {
        notes.add({
          'title': taskTitle,
          'content': taskDescription,
          'done': false,
          'file': 'none',
        });
      }

      _taskTitleController.clear();
      _taskDescriptionController.clear();

      if (context.mounted) Navigator.pop(context); // Close the add task screen
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
                child: TextFormField(
                  controller: _taskDescriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  maxLines: 5,
                ),
              ),
              spacer,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _selectFile,
                    icon: const Icon(Icons.add_photo_alternate),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addTaskToList();
                    },
                    child: const Text('Add Task'),
                  ),
                ],
              ),
              const Spacer(),
              const Text('Image preview'),
              if (_file != null)
                ListTile(
                  leading: Image.file(File(_file!.path!), fit: BoxFit.cover),
                  title: Text(_file!.name),
                  subtitle: Text(_file!.size.toString()),
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        _file = null;
                      });
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ),
              if (_file == null)
                const ListTile(
                  leading: Icon(Icons.image),
                  title: Text('No image selected'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
