import 'package:flutter/material.dart';
import '../models/daily_faith_record.dart';
import '../services/firestore_service.dart';

class FaithProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  
  DailyFaithRecord? _todayRecord;
  bool _isLoading = false;
  String? _error;

  DailyFaithRecord? get todayRecord => _todayRecord;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTodayRecord(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _todayRecord = await _service.getTodayFaithRecord(userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleSalah(String userId, String salahName) async {
    if (_todayRecord == null) return;
    final updated = Map<String, bool>.from(_todayRecord!.salahCompleted);
    updated[salahName] = !(updated[salahName] ?? false);
    _todayRecord = _todayRecord!.copyWith(salahCompleted: updated);
    notifyListeners();
    await _service.updateFaithRecord(_todayRecord!);
  }

  Future<void> updateQuranPages(String userId, int pages) async {
    if (_todayRecord == null) return;
    _todayRecord = _todayRecord!.copyWith(quranPagesRead: pages);
    notifyListeners();
    await _service.updateFaithRecord(_todayRecord!);
  }

  Future<void> incrementDhikr(String userId) async {
    if (_todayRecord == null) return;
    _todayRecord = _todayRecord!.copyWith(
      dhikrCount: (_todayRecord!.dhikrCount + 1),
    );
    notifyListeners();
    await _service.updateFaithRecord(_todayRecord!);
  }

  Future<void> resetDhikr(String userId) async {
    if (_todayRecord == null) return;
    _todayRecord = _todayRecord!.copyWith(dhikrCount: 0);
    notifyListeners();
    await _service.updateFaithRecord(_todayRecord!);
  }

  Future<void> saveGratitudeNote(String userId, String note) async {
    if (_todayRecord == null) return;
    _todayRecord = _todayRecord!.copyWith(gratitudeNote: note);
    notifyListeners();
    await _service.updateFaithRecord(_todayRecord!);
  }
}
