import 'package:flutter/material.dart';
import 'note_detailed_screen.dart'; // Destination screen where the hero lands

class NoteCard extends StatelessWidget {
  final String title;
  final String content;
  final String docId;
  final VoidCallback onDelete;
  final VoidCallback onLongPress;

  const NoteCard({
    super.key,
    required this.title,
    required this.content,
    required this.docId,
    required this.onDelete,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 🚀 THE TRIGGER: Transitions to the detail viewing screen on a single tap
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NoteDetailedScreen(
              title: title,
              content: content,
              docId: docId,
            ),
          ),
        );
      },
      // 📝 THE SHEET ACTION: Long press triggers the bottom update sheet modal
      onLongPress: onLongPress,

      // 🎨 THE CONTAINER: Gives the card its structural shape, background surface, and soft shadow
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  // ✈️ HERO FLIGHT 1: Captures the title text block to fly it over
                  child: Hero(
                    tag: 'title-$docId', // Unique tag pairing
                    child: Material(
                      color: Colors.transparent, // Prevents text style rendering glitches mid-flight
                      child: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                // 🛑 DELETE INTERACTION: Instantly deletes the document matching its ID
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 4),

            // ✈️ HERO FLIGHT 2: Captures the snippet description block to fly it over
            Hero(
              tag: 'content-$docId', // Unique tag pairing
              child: Material(
                color: Colors.transparent,
                child: Text(
                  content,
                  style: TextStyle(color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: 4),

            // 💡 HELPER CAPTION: Tells the user how to manipulate this specific block
            const Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Hold to edit • Tap to open',
                style: TextStyle(fontSize: 10, color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}