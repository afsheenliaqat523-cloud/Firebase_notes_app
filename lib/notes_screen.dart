import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes_app/note_card.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  // ➕ CREATE: Save Note to Firestore
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
if (mounted) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text('Note added successfully!'), backgroundColor: Colors.green),
);
}
} on FirebaseException catch (e) {
// Catches specific Firebase server issues
if (mounted) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text('Firebase Error: ${e.message}'), backgroundColor: Colors.redAccent),
);
}
} catch (e) {
// Catches generic fallback exceptions
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred: $e'),
              backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  // 📝 UPDATE: Show bottom sheet edit drawer
  void _showEditingDialogue(String docId, String currentTitle, String currentContent) {
    final editTitleController = TextEditingController(text: currentTitle);
    final editContentController = TextEditingController(text: currentContent);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows sheet to push above the keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Avoids keyboard overlap
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Edit Note',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: editTitleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: editContentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: () async {
                  final updatedTitle = editTitleController.text.trim();
                  final updatedContent = editContentController.text.trim();

                  if (updatedTitle.isEmpty || updatedContent.isEmpty) return;

                  try {
                    // Update document directly using its ID
                    await fireStore.collection('notes').doc(docId).update({
                      'title': updatedTitle,
                      'content': updatedContent,
                      'lastEdited': FieldValue.serverTimestamp(),
                    });

                    if (context.mounted) Navigator.pop(context); // Close sheet safely
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Update failed: $e')),
                    );
                  }
                },
                icon: const Icon(Icons.check),
                label: const Text('Save Changes'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    ).then((_) {
      // Clean up controllers once the modal is closed
      editTitleController.dispose();
      editContentController.dispose();
    });
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
        title: const Text("Cloud Notes"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          // 👤 Profile Header
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

          // 📝 Input Fields UI
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

          // 📖 Live Feed Stream
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
                    final docId = docs[index].id;
                    final data = docs[index].data() as Map<String, dynamic>;
                    final title = data['title'] ?? '';
                    final content = data['content'] ?? '';

                    return NoteCard(
                      title: title,
                      content: content,
                      docId: docId,
                      onDelete: () => fireStore.collection('notes').doc(docId).delete(),
                      onLongPress: () => _showEditingDialogue(docId, title, content),
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
