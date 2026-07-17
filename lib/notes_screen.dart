import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // 👈 Make sure this is here!

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final fireStore = FirebaseFirestore.instance;
  String? _localProfilePath;

  // 📷 Local profile picture picker
  Future<void> _pickLocalProfile() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _localProfilePath = pickedFile.path;
      });
    }
  }

  void addNotes() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) return;
    try {
      await fireStore.collection('notes').add({
        'title': title,
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _titleController.clear();
      _contentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error saving notes:$e')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cloud Notes"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => FirebaseAuth.instance.signOut(), // 🌟 Log out instantly!
            ),
          ],
        ),
      body: Column(
        children: [
          // 👤 Mock Local Profile Header
          Container(
            padding: const EdgeInsets.all(12.0),
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _pickLocalProfile,
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _localProfilePath != null ? FileImage(File(_localProfilePath!)) : null,
                    child: _localProfilePath == null ? const Icon(Icons.camera_alt, color: Colors.grey) : null,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Developer Workspace', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // 📝 CREATE UI: Input Fields
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(labelText: 'Content...', border: OutlineInputBorder()),
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: addNotes,
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(45)),
                  icon: const Icon(Icons.save),
                  label: const Text('Save Note to Cloud'),
                ),
              ],
            ),
          ),
          const Divider(),

          // 📖 READ UI: Displaying List from Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: fireStore.collection('notes').orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) return const Center(child: Text('No notes found.'));

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: ListTile(
                        title: Text(data['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(data['content'] ?? ''),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => fireStore.collection('notes').doc(docs[index].id).delete(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}