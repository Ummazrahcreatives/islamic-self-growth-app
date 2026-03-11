import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/habits_provider.dart';
import '../../models/habit_model.dart';
import '../../utils/app_theme.dart';
import '../../widgets/habits/habit_tile.dart';
import '../../widgets/habits/add_habit_sheet.dart';
import '../../widgets/habits/habit_progress_ring.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habits = context.watch<HabitsProvider>();
    final user = context.watch<AuthProvider>().user;

    final grouped = <String, List<HabitModel>>{};
    for (final h in habits.habits) {
      grouped.putIfAbsent(h.category, () => []).add(h);
    }

    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppColors.primaryGreen),
            onPressed: () => _showAddHabitSheet(context, user?.uid ?? ''),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Summary
          Container(
            margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryGreen, Color(0xFF52B788)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                HabitProgressRing(
                  progress: habits.todayProgress,
                  completed: habits.completedToday,
                  total: habits.habits.length,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Today's Progress",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${habits.completedToday} of ${habits.habits.length} habits completed',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (habits.longestStreak > 0)
                        Row(
                          children: [
                            const Text('🔥', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 4),
                            Text(
                              '${habits.longestStreak} day best streak',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Habits list
          Expanded(
            child: habits.habits.isEmpty
                ? _emptyState(context)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    itemCount: grouped.length,
                    itemBuilder: (ctx, i) {
                      final category = grouped.keys.elementAt(i);
                      final categoryHabits = grouped[category]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8, top: 8),
                            child: _categoryChip(context, category),
                          ),
                          ...categoryHabits.map((h) => HabitTile(habit: h)),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddHabitSheet(context, user?.uid ?? ''),
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Add Habit',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _categoryChip(BuildContext context, String category) {
    final categoryColors = {
      'Spiritual': AppColors.primaryGreen,
      'Physical': AppColors.info,
      'Mental': const Color(0xFF7B6FB5),
      'Emotional': AppColors.roseWarm,
      'Financial': AppColors.gold,
    };
    final color = categoryColors[category] ?? AppColors.primaryGreen;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Nunito',
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🌱', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(
            'Start building habits',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Small consistent actions lead to\ngreat transformation',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  void _showAddHabitSheet(BuildContext context, String userId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddHabitSheet(userId: userId),
    );
  }
}
