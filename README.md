# Flutter Firebase Project

This Flutter project integrates Firebase services for authentication, database, and storage. It's built using the [FlutterFire](https://github.com/FirebaseExtended/flutterfire) plugins for Firebase.

## Table of Contents

- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Firebase Configuration](#firebase-configuration)
  - [Authentication](#authentication)
  - [Cloud Firestore](#cloud-firestore)
  - [Firebase Storage](#firebase-storage)
- [Usage](#usage)
  - [Authentication](#authentication-usage)
  - [Cloud Firestore](#cloud-firestore-usage)
  - [Firebase Storage](#firebase-storage-usage)
- [Contributing](#contributing)
- [License](#license)

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Firebase Project: Create a new project on the [Firebase Console](https://console.firebase.google.com/).
- Firebase Configuration Files: Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) from Firebase Console and place them in the respective folders.

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/Xelame/firebase.git
   ```

2. Navigate to the project directory:

   ```bash
   cd firebase
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

## Firebase Configuration

### Authentication

1. Enable the Authentication service in the Firebase Console.
2. Follow the setup instructions to configure authentication providers.

### Cloud Firestore

1. Enable Cloud Firestore in the Firebase Console.
2. Set up your Firestore database and collections.

### Firebase Storage

1. Enable Firebase Storage in the Firebase Console.
2. Set up your storage buckets and permissions.

## Usage

### Authentication Usage

```dart
// Sign in 
await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: _emailController.text,
    password: _passwordController.text,
);

// Sign up
await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: _emailController.text,
    password: _passwordController.text,
);

```

### Cloud Firestore Usage

```dart
// Writing Data
final notes = FirebaseFirestore.instance.collection('notes');

notes.add({
          'title': taskTitle,
          'content': taskDescription,
          'done': false,
          'file': 'file/${_file!.name}',
        }
);

// Reading Data
StreamBuilder<QuerySnapshot>(
        stream: notes.snapshots(),
        ...
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                ...
                title: Text(data['title']),
                subtitle: Text(data['content']),
                ...
```

### Firebase Storage Usage

```dart
// Upload File
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
    
    setState(() {
      _task = null;
    });
  }
```

## Contributing

Contributions are welcome! See the [Contributing Guidelines](CONTRIBUTING.md) for more details.

## License

This project is licensed under the [MIT License](LICENSE).
