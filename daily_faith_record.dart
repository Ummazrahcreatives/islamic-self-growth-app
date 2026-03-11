import 'package:cloud_firestore/cloud_firestore.dart';

class DailyFaithRecord {
  final String id;
  final String userId;
  final DateTime date;
  final Map<String, bool> salahCompleted; // fajr, dhuhr, asr, maghrib, isha
  final int quranPagesRead;
  final int dhikrCount;
  final String? gratitudeNote;
  final int completionScore; // 0-100

  DailyFaithRecord({
    required this.id,
    required this.userId,
    required this.date,
    Map<String, bool>? salahCompleted,
    this.quranPagesRead = 0,
    this.dhikrCount = 0,
    this.gratitudeNote,
    this.completionScore = 0,
  }) : salahCompleted = salahCompleted ?? {
    'fajr': false,
    'dhuhr': false,
    'asr': false,
    'maghrib': false,
    'isha': false,
  };

  int get salahCount => salahCompleted.values.where((v) => v).length;

  int get calculatedScore {
    int score = 0;
    score += salahCount * 12; // 5 prayers = 60 pts
    score += (quranPagesRead > 0) ? 20 : 0;
    score += (dhikrCount >= 33) ? 10 : (dhikrCount > 0 ? 5 : 0);
    score += (gratitudeNote != null && gratitudeNote!.isNotEmpty) ? 10 : 0;
    return score.clamp(0, 100);
  }

  factory DailyFaithRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DailyFaithRecord(
      id: doc.id,
      userId: data['userId'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      salahCompleted: Map<String, bool>.from(data['salahCompleted'] ?? {}),
      quranPagesRead: data['quranPagesRead'] ?? 0,
      dhikrCount: data['dhikrCount'] ?? 0,
      gratitudeNote: data['gratitudeNote'],
      completionScore: data['completionScore'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'salahCompleted': salahCompleted,
      'quranPagesRead': quranPagesRead,
      'dhikrCount': dhikrCount,
      'gratitudeNote': gratitudeNote,
      'completionScore': calculatedScore,
    };
  }

  DailyFaithRecord copyWith({
    Map<String, bool>? salahCompleted,
    int? quranPagesRead,
    int? dhikrCount,
    String? gratitudeNote,
  }) {
    return DailyFaithRecord(
      id: id,
      userId: userId,
      date: date,
      salahCompleted: salahCompleted ?? Map.from(this.salahCompleted),
      quranPagesRead: quranPagesRead ?? this.quranPagesRead,
      dhikrCount: dhikrCount ?? this.dhikrCount,
      gratitudeNote: gratitudeNote ?? this.gratitudeNote,
    );
  }

  String get dateKey {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
