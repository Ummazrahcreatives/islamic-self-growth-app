import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/auth_provider.dart';
import '../../providers/habits_provider.dart';
import '../../providers/journal_provider.dart';
import '../../providers/faith_provider.dart';
import '../../utils/app_theme.dart';
import '../../services/firestore_service.dart';

class GrowthScreen extends StatefulWidget {
  const GrowthScreen({super.key});

  @override
  State<GrowthScreen> createState() => _GrowthScreenState();
}

class _GrowthScreenState extends State<GrowthScreen> {
  Map<String, dynamic>? _stats;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    final stats = await FirestoreService().getUserStats(user.uid);
    setState(() {
      _stats = stats;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final habits = context.watch<HabitsProvider>();
    final journal = context.watch<JournalProvider>();

    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      appBar: AppBar(title: const Text('My Growth')),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top stats row
                  Row(
                    children: [
                      _StatCard(
                        emoji: '🔥',
                        value: '${_stats?['maxStreak'] ?? 0}',
                        label: 'Best Streak',
                        color: const Color(0xFFFF6B35),
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        emoji: '✅',
                        value: '${habits.habits.length}',
                        label: 'Active Habits',
                        color: AppColors.primaryGreen,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _StatCard(
                        emoji: '📓',
                        value: '${journal.totalEntries}',
                        label: 'Reflections',
                        color: const Color(0xFF7B6FB5),
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        emoji: '🕌',
                        value: '${(_stats?['avgFaithScore'] ?? 0.0).toStringAsFixed(0)}',
                        label: 'Avg Faith Score',
                        color: AppColors.gold,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Habits by category
                  Text('Habits by Category',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  _HabitCategoryBreakdown(habits: habits),

                  const SizedBox(height: 28),

                  // Today's completion
                  Text('Today\'s Habit Completion',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  _TodayCompletionList(habits: habits),

                  const SizedBox(height: 28),

                  // Motivational footer
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryGreen,
                          AppColors.lightGreen,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text('🌙', style: TextStyle(fontSize: 32)),
                        const SizedBox(height: 10),
                        const Text(
                          '"The best deeds are those done consistently, even if they are small."',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Nunito',
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '— Prophet Muhammad ﷺ',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: color,
                fontFamily: 'Nunito',
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textMedium,
                fontFamily: 'Nunito',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitCategoryBreakdown extends StatelessWidget {
  final HabitsProvider habits;
  const _HabitCategoryBreakdown({required this.habits});

  @override
  Widget build(BuildContext context) {
    final categories = <String, int>{};
    for (final h in habits.habits) {
      categories[h.category] = (categories[h.category] ?? 0) + 1;
    }

    if (categories.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.beige,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'No habits added yet',
          style: TextStyle(fontFamily: 'Nunito', color: AppColors.textLight),
        ),
      );
    }

    final colors = [
      AppColors.primaryGreen,
      AppColors.info,
      const Color(0xFF7B6FB5),
      AppColors.roseWarm,
      AppColors.gold,
    ];

    return Column(
      children: categories.entries.toList().asMap().entries.map((e) {
        final index = e.key;
        final entry = e.value;
        final fraction = entry.value / habits.habits.length;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMedium,
                    ),
                  ),
                  Text(
                    '${entry.value} habit${entry.value > 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: fraction,
                  backgroundColor:
                      colors[index % colors.length].withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation(
                      colors[index % colors.length]),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _TodayCompletionList extends StatelessWidget {
  final HabitsProvider habits;
  const _TodayCompletionList({required this.habits});

  @override
  Widget build(BuildContext context) {
    if (habits.habits.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: habits.habits.map((h) {
        final done = h.isCompletedToday();
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: done ? AppColors.paleGreen : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: done
                  ? AppColors.lightGreen.withOpacity(0.4)
                  : AppColors.sandstone,
            ),
          ),
          child: Row(
            children: [
              Text(h.icon, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  h.name,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    color: done ? AppColors.primaryGreen : AppColors.textMedium,
                    fontWeight: done ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              Row(
                children: [
                  if (h.currentStreak > 0)
                    Text(
                      '🔥 ${h.currentStreak}',
                      style: const TextStyle(fontSize: 12, fontFamily: 'Nunito'),
                    ),
                  const SizedBox(width: 8),
                  Icon(
                    done
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    color: done
                        ? AppColors.primaryGreen
                        : AppColors.textLight,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
