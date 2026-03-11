import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/habit_model.dart';
import '../models/daily_faith_record.dart';
import '../models/journal_entry.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ---- DAILY FAITH ----

  Future<DailyFaithRecord> getTodayFaithRecord(String userId) async {
    final today = DateTime.now();
    final dateKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final docId = '${userId}_$dateKey';

    final doc = await _db.collection('faith_records').doc(docId).get();
    if (doc.exists) {
      return DailyFaithRecord.fromFirestore(doc);
    }

    final record = DailyFaithRecord(
      id: docId,
      userId: userId,
      date: today,
    );
    await _db.collection('faith_records').doc(docId).set(record.toMap());
    return record;
  }

  Future<void> updateFaithRecord(DailyFaithRecord record) async {
    await _db
        .collection('faith_records')
        .doc(record.id)
        .set(record.toMap(), SetOptions(merge: true));
  }

  Future<List<DailyFaithRecord>> getFaithHistory(
      String userId, int days) async {
    final from = DateTime.now().subtract(Duration(days: days));
    final snapshot = await _db
        .collection('faith_records')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThan: Timestamp.fromDate(from))
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs.map((d) => DailyFaithRecord.fromFirestore(d)).toList();
  }

  // ---- HABITS ----

  Stream<List<HabitModel>> habitsStream(String userId) {
    return _db
        .collection('habits')
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => HabitModel.fromFirestore(d)).toList());
  }

  Future<void> createHabit(HabitModel habit) async {
    await _db.collection('habits').doc(habit.id).set(habit.toMap());
  }

  Future<void> updateHabit(HabitModel habit) async {
    await _db
        .collection('habits')
        .doc(habit.id)
        .update(habit.toMap());
  }

  Future<void> toggleHabitCompletion(HabitModel habit) async {
    final today = DateTime.now();
    final isCompleted = habit.isCompletedToday();

    List<DateTime> updatedDates = List.from(habit.completedDates);
    int newStreak = habit.currentStreak;
    int newTotal = habit.totalCompletions;

    if (isCompleted) {
      updatedDates.removeWhere((d) =>
          d.year == today.year &&
          d.month == today.month &&
          d.day == today.day);
      newStreak = (newStreak - 1).clamp(0, 999);
      newTotal = (newTotal - 1).clamp(0, 99999);
    } else {
      updatedDates.add(today);
      newStreak++;
      newTotal++;
    }

    final longest = newStreak > habit.longestStreak
        ? newStreak
        : habit.longestStreak;

    await _db.collection('habits').doc(habit.id).update({
      'completedDates': updatedDates.map((d) => Timestamp.fromDate(d)).toList(),
      'currentStreak': newStreak,
      'longestStreak': longest,
      'totalCompletions': newTotal,
    });
  }

  Future<void> deleteHabit(String habitId) async {
    await _db.collection('habits').doc(habitId).update({'isActive': false});
  }

  // ---- JOURNAL ----

  Stream<List<JournalEntry>> journalStream(String userId) {
    return _db
        .collection('journal_entries')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => JournalEntry.fromFirestore(d)).toList());
  }

  Future<void> createJournalEntry(JournalEntry entry) async {
    await _db
        .collection('journal_entries')
        .doc(entry.id)
        .set(entry.toMap());
  }

  Future<void> updateJournalEntry(JournalEntry entry) async {
    await _db.collection('journal_entries').doc(entry.id).update({
      'content': entry.content,
      'mood': entry.mood,
      'tags': entry.tags,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> deleteJournalEntry(String entryId) async {
    await _db.collection('journal_entries').doc(entryId).delete();
  }

  // ---- USER STATS ----

  Future<Map<String, dynamic>> getUserStats(String userId) async {
    final habits = await _db
        .collection('habits')
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .get();

    final journals = await _db
        .collection('journal_entries')
        .where('userId', isEqualTo: userId)
        .get();

    final faithRecords = await _db
        .collection('faith_records')
        .where('userId', isEqualTo: userId)
        .get();

    int maxStreak = 0;
    for (final doc in habits.docs) {
      final streak = doc.data()['currentStreak'] ?? 0;
      if (streak > maxStreak) maxStreak = streak;
    }

    double avgFaithScore = 0;
    if (faithRecords.docs.isNotEmpty) {
      final totalScore = faithRecords.docs.fold<int>(
          0, (sum, doc) => sum + (doc.data()['completionScore'] as int? ?? 0));
      avgFaithScore = totalScore / faithRecords.docs.length;
    }

    return {
      'totalHabits': habits.docs.length,
      'totalJournalEntries': journals.docs.length,
      'maxStreak': maxStreak,
      'avgFaithScore': avgFaithScore,
      'totalFaithDays': faithRecords.docs.length,
    };
  }
}
