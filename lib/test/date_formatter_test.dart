import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_notes_app/utils/date_formatter.dart'; // Adjust path based on your package name

void main() {
  // group lets us bundle related tests together beautifully
  group('DateFormatter Tests', () {

    test('Should return "Unknown date" when DateTime is null', () {
      final result = DateFormatter.formatTimestamp(null);
      expect(result, 'Unknown date');
    });

    test('Should return "Just now" for current timestamps', () {
      final currentTime = DateTime.now();
      final result = DateFormatter.formatTimestamp(currentTime);
      expect(result, 'Just now');
    });

    test('Should return minutes ago for recent timestamps', () {
      final tenMinutesAgo = DateTime.now().subtract(const Duration(minutes: 10));
      final result = DateFormatter.formatTimestamp(tenMinutesAgo);
      expect(result, '10m ago');
    });

  });
}