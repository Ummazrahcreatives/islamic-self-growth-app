import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/habit_model.dart';
import '../services/firestore_service.dart';
import '../utils/app_theme.dart';

class HabitsProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  final _uuid = const Uuid();

  List<HabitModel> _habits = [];
  bool _isLoading = false;
  String? _error;
  String? _userId;

  List<HabitModel> get habits => _habits;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  List<HabitModel> get todayHabits => _habits;
  
  int get completedToday => _habits.where((h) => h.isCompletedToday()).length;
  
  double get todayProgress => _habits.isEmpty ? 0 : completedToday / _habits.length;

  int get longestStreak {
    if (_habits.isEmpty) return 0;
    return _habits.map((h) => h.currentStreak).reduce((a, b) => a > b ? a : b);
  }

  void initialize(String userId) {
    _userId = userId;
    _service.habitsStream(userId).listen((habits) {
      _habits = habits;
      notifyListeners();
    });
  }

  Future<void> createDefaultHabits(String userId) async {
    _userId = userId;
    for (final habitData in AppConstants.defaultHabits) {
      final habit = HabitModel(
        id: _uuid.v4(),
        userId: userId,
        name: habitData['name'] as String,
        category: habitData['category'] as String,
        icon: habitData['icon'] as String,
        createdAt: DateTime.now(),
      );
      await _service.createHabit(habit);
    }
  }

  Future<void> addHabit({
    required String userId,
    required String name,
    required String category,
    required String icon,
  }) async {
    final habit = HabitModel(
      id: _uuid.v4(),
      userId: userId,
      name: name,
      category: category,
      icon: icon,
      createdAt: DateTime.now(),
    );
    await _service.createHabit(habit);
  }

  Future<void> toggleHabit(HabitModel habit) async {
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index == -1) return;

    final today = DateTime.now();
    final isCompleted = habit.isCompletedToday();
    List<DateTime> updatedDates = List.from(habit.completedDates);

    if (isCompleted) {
      updatedDates.removeWhere((d) =>
          d.year == today.year && d.month == today.month && d.day == today.day);
    } else {
      updatedDates.add(today);
    }

    final newStreak = isCompleted
        ? (habit.currentStreak - 1).clamp(0, 999)
        : habit.currentStreak + 1;

    _habits[index] = habit.copyWith(
      completedDates: updatedDates,
      currentStreak: newStreak,
      longestStreak: newStreak > habit.longestStreak ? newStreak : habit.longestStreak,
      totalCompletions: isCompleted
          ? (habit.totalCompletions - 1).clamp(0, 99999)
          : habit.totalCompletions + 1,
    );
    notifyListeners();

    await _service.toggleHabitCompletion(habit);
  }

  Future<void> deleteHabit(String habitId) async {
    _habits.removeWhere((h) => h.id == habitId);
    notifyListeners();
    await _service.deleteHabit(habitId);
  }
}
