import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/habit_model.dart';
import '../../providers/habits_provider.dart';
import '../../utils/app_theme.dart';

class HabitTile extends StatelessWidget {
  final HabitModel habit;

  const HabitTile({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final habits = context.read<HabitsProvider>();
    final isCompleted = habit.isCompletedToday();

    return Dismissible(
      key: Key(habit.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(Icons.delete_outline, color: AppColors.error),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Remove habit?'),
            content: Text('Remove "${habit.name}" from your tracker?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel')),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Remove',
                    style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
        ) ?? false;
      },
      onDismissed: (_) => habits.deleteHabit(habit.id),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          habits.toggleHabit(habit);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isCompleted ? AppColors.paleGreen : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isCompleted
                  ? AppColors.lightGreen.withOpacity(0.5)
                  : AppColors.sandstone,
            ),
          ),
          child: Row(
            children: [
              Text(habit.icon, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isCompleted
                            ? AppColors.primaryGreen
                            : AppColors.textDark,
                        decoration: isCompleted
                            ? TextDecoration.none
                            : null,
                      ),
                    ),
                    if (habit.currentStreak > 0)
                      Text(
                        '🔥 ${habit.currentStreak} day streak',
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 11,
                          color: AppColors.textLight,
                        ),
                      ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.primaryGreen
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCompleted
                        ? AppColors.primaryGreen
                        : AppColors.sandstone,
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 16)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
