import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/journal_entry.dart';
import '../services/firestore_service.dart';

class JournalProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  final _uuid = const Uuid();

  List<JournalEntry> _entries = [];
  bool _isLoading = false;

  List<JournalEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  int get totalEntries => _entries.length;

  void initialize(String userId) {
    _service.journalStream(userId).listen((entries) {
      _entries = entries;
      notifyListeners();
    });
  }

  Future<void> addEntry({
    required String userId,
    required String content,
    String? prompt,
    String mood = 'content',
    List<String> tags = const [],
  }) async {
    final entry = JournalEntry(
      id: _uuid.v4(),
      userId: userId,
      content: content,
      prompt: prompt,
      mood: mood,
      tags: tags,
      createdAt: DateTime.now(),
    );
    _entries.insert(0, entry);
    notifyListeners();
    await _service.createJournalEntry(entry);
  }

  Future<void> deleteEntry(String entryId) async {
    _entries.removeWhere((e) => e.id == entryId);
    notifyListeners();
    await _service.deleteJournalEntry(entryId);
  }

  List<JournalEntry> getEntriesForMonth(DateTime month) {
    return _entries.where((e) =>
        e.createdAt.year == month.year &&
        e.createdAt.month == month.month).toList();
  }
}
