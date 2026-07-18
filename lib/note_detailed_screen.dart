import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoteDetailedScreen extends StatelessWidget {
  final String title;
  final String content;
  final String docId;

  const NoteDetailedScreen({
    super.key,
    required this.title,
    required this.content,
    required this.docId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Note'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(tag: 'title-$docId',
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                )),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 12),
            // 🌟 HERO TARGET 2: The Content Text Block
            Hero(
              tag: 'content-$docId',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
