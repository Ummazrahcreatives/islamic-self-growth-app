import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/daily_faith_record.dart';
import '../../providers/faith_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_theme.dart';

class FaithTrackerCard extends StatelessWidget {
  final DailyFaithRecord record;

  const FaithTrackerCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthProvider>().user?.uid ?? '';
    final faith = context.read<FaithProvider>();

    final prayers = [
      {'key': 'fajr', 'label': 'Fajr', 'time': 'Dawn', 'icon': '🌙'},
      {'key': 'dhuhr', 'label': 'Dhuhr', 'time': 'Midday', 'icon': '☀️'},
      {'key': 'asr', 'label': 'Asr', 'time': 'Afternoon', 'icon': '🌤️'},
      {'key': 'maghrib', 'label': 'Maghrib', 'time': 'Sunset', 'icon': '🌅'},
      {'key': 'isha', 'label': 'Isha', 'time': 'Night', 'icon': '🌌'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.sandstone),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${record.salahCount}/5 prayers',
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                record.salahCount == 5 ? '✨ Complete!' : 'Keep going',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12,
                  color: record.salahCount == 5
                      ? AppColors.primaryGreen
                      : AppColors.textLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: prayers.map((p) {
              final key = p['key'] as String;
              final completed = record.salahCompleted[key] ?? false;
              return GestureDetector(
                onTap: () => faith.toggleSalah(userId, key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 56,
                  height: 70,
                  decoration: BoxDecoration(
                    color: completed
                        ? AppColors.primaryGreen
                        : AppColors.beige,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: completed
                          ? AppColors.primaryGreen
                          : AppColors.sandstone,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        p['icon'] as String,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p['label'] as String,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 11,
                          color:
                              completed ? Colors.white : AppColors.textMedium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
