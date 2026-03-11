import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/daily_faith_record.dart';
import '../../providers/faith_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_theme.dart';

class QuranTrackerCard extends StatelessWidget {
  final DailyFaithRecord record;

  const QuranTrackerCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthProvider>().user?.uid ?? '';
    final faith = context.read<FaithProvider>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.sandstone),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📖', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${record.quranPagesRead} pages read today',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      'Goal: 3 pages daily (1 juz/week)',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (record.quranPagesRead / 3).clamp(0.0, 1.0),
              backgroundColor: AppColors.beige,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [1, 2, 3, 5, 10].map((pages) {
              final isSelected = record.quranPagesRead == pages;
              return GestureDetector(
                onTap: () => faith.updateQuranPages(userId, pages),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryGreen
                        : AppColors.beige,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: isSelected
                            ? AppColors.primaryGreen
                            : AppColors.sandstone),
                  ),
                  child: Text(
                    '$pages pg',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textMedium,
                    ),
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
