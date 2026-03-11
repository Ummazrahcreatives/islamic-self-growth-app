import 'package:cloud_firestore/cloud_firestore.dart';

class HabitModel {
  final String id;
  final String userId;
  final String name;
  final String category;
  final String icon;
  final bool isActive;
  final int currentStreak;
  final int longestStreak;
  final int totalCompletions;
  final DateTime createdAt;
  final List<DateTime> completedDates;

  HabitModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.icon,
    this.isActive = true,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalCompletions = 0,
    required this.createdAt,
    this.completedDates = const [],
  });

  bool isCompletedToday() {
    final today = DateTime.now();
    return completedDates.any((date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day);
  }

  bool isCompletedOnDate(DateTime date) {
    return completedDates.any((d) =>
        d.year == date.year && d.month == date.month && d.day == date.day);
  }

  factory HabitModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final datesRaw = data['completedDates'] as List<dynamic>? ?? [];
    return HabitModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      category: data['category'] ?? 'Spiritual',
      icon: data['icon'] ?? '⭐',
      isActive: data['isActive'] ?? true,
      currentStreak: data['currentStreak'] ?? 0,
      longestStreak: data['longestStreak'] ?? 0,
      totalCompletions: data['totalCompletions'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedDates: datesRaw
          .map((d) => (d as Timestamp).toDate())
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'category': category,
      'icon': icon,
      'isActive': isActive,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'totalCompletions': totalCompletions,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedDates': completedDates.map((d) => Timestamp.fromDate(d)).toList(),
    };
  }

  HabitModel copyWith({
    String? name,
    String? category,
    String? icon,
    bool? isActive,
    int? currentStreak,
    int? longestStreak,
    int? totalCompletions,
    List<DateTime>? completedDates,
  }) {
    return HabitModel(
      id: id,
      userId: userId,
      name: name ?? this.name,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalCompletions: totalCompletions ?? this.totalCompletions,
      createdAt: createdAt,
      completedDates: completedDates ?? this.completedDates,
    );
  }
}
