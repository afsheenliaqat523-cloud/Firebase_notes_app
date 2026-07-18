class DateFormatter {
  static String formatTimestamp(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown date';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      // Clean fallback string formatting
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}