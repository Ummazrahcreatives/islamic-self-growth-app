import 'package:flutter/material.dart';
import 'dart:math';
import '../../utils/app_theme.dart';

class QuoteBanner extends StatefulWidget {
  const QuoteBanner({super.key});

  @override
  State<QuoteBanner> createState() => _QuoteBannerState();
}

class _QuoteBannerState extends State<QuoteBanner> {
  late Map<String, String> _quote;

  @override
  void initState() {
    super.initState();
    _quote = AppConstants.islamicQuotes[
        Random().nextInt(AppConstants.islamicQuotes.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.softGold,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _quote['arabic'] ?? '',
            style: const TextStyle(
              fontFamily: 'Amiri',
              fontSize: 22,
              color: AppColors.textDark,
              height: 1.8,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '"${_quote['translation']}"',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13,
              color: AppColors.textMedium,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            _quote['source'] ?? '',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 12,
              color: AppColors.warmTaupe,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
