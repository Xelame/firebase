import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/pages/add_task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MyHomePageLogged extends StatefulWidget {
  const MyHomePageLogged({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePageLogged> createState() => _MyHomePageLoggedState();
}

class _MyHomePageLoggedState extends State<MyHomePageLogged> {
  final notes = FirebaseFirestore.instance.collection('notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Todo App'),
        actions: [
          Text(FirebaseAuth.instance.currentUser!.email!),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.logout),
          )
        ],
        // remove arrow back
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: notes.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                leading: data['file'] != 'none' ? FutureBuilder<String>(
                  future: FirebaseStorage.instance
                      .ref(data['file'])
                      .getDownloadURL(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Icon(Icons.error);
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    return Image.network(snapshot.data!);
                  },
                ) : const Icon(Icons.image_not_supported),
                title: Text(data['title']),
                subtitle: Text(data['content']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: data['done'],
                      onChanged: (bool? value) {
                        notes.doc(document.id).update({'done': value});
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        notes.doc(document.id).delete();
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddTaskPage()));
        },
        label: const Text('Add Task'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
