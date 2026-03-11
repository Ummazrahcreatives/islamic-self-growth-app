import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/daily_faith_record.dart';
import '../../providers/faith_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_theme.dart';

class DhikrCounterCard extends StatelessWidget {
  final DailyFaithRecord record;

  const DhikrCounterCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthProvider>().user?.uid ?? '';
    final faith = context.read<FaithProvider>();
    final count = record.dhikrCount;
    final progress = (count / 99).clamp(0.0, 1.0);

    final dhikrText = count < 34
        ? 'سُبْحَانَ اللهِ\nSubhanAllah'
        : count < 67
            ? 'الْحَمْدُ لِلَّهِ\nAlhamdulillah'
            : 'اللَّهُ أَكْبَرُ\nAllahu Akbar';

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
              Row(
                children: [
                  const Text('📿', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    'Tasbih Counter',
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => faith.resetDhikr(userId),
                child: Text(
                  'Reset',
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 12,
                    fontFamily: 'Nunito',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              faith.incrementDhikr(userId);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.paleGreen,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.lightGreen.withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  Text(
                    '$count',
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  Text(
                    dhikrText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 16,
                      color: AppColors.primaryGreen,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to count',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.beige,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primaryGreen),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '$count/99',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
