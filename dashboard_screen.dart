import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/faith_provider.dart';
import '../../providers/habits_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/dashboard/faith_tracker_card.dart';
import '../../widgets/dashboard/quran_tracker_card.dart';
import '../../widgets/dashboard/dhikr_counter_card.dart';
import '../../widgets/dashboard/gratitude_card.dart';
import '../../widgets/dashboard/quote_banner.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      context.read<FaithProvider>().loadTodayRecord(user.uid);
      context.read<HabitsProvider>().initialize(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final faith = context.watch<FaithProvider>();
    final now = DateTime.now();
    final greeting = _greeting(now.hour);
    final dateStr = DateFormat('EEEE, d MMMM').format(now);

    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primaryGreen,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryGreen,
                      Color(0xFF40916C),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '$greeting, ${user?.displayName ?? 'beloved'} 🌿',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateStr,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (faith.todayRecord != null) ...[
                        _buildProgressBar(faith.todayRecord!.calculatedScore),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  radius: 18,
                  child: Text(
                    (user?.displayName ?? 'M')[0].toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Nunito'),
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const QuoteBanner(),
                  const SizedBox(height: 24),
                  _sectionTitle(context, "Today's Faith"),
                  const SizedBox(height: 12),
                  if (faith.todayRecord != null)
                    FaithTrackerCard(record: faith.todayRecord!),
                  const SizedBox(height: 20),
                  _sectionTitle(context, 'Quran Reading'),
                  const SizedBox(height: 12),
                  if (faith.todayRecord != null)
                    QuranTrackerCard(record: faith.todayRecord!),
                  const SizedBox(height: 20),
                  _sectionTitle(context, 'Dhikr Counter'),
                  const SizedBox(height: 12),
                  if (faith.todayRecord != null)
                    DhikrCounterCard(record: faith.todayRecord!),
                  const SizedBox(height: 20),
                  _sectionTitle(context, 'Gratitude Reflection'),
                  const SizedBox(height: 12),
                  if (faith.todayRecord != null)
                    GratitudeCard(record: faith.todayRecord!),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16),
    );
  }

  Widget _buildProgressBar(int score) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daily faith score',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                  fontFamily: 'Nunito'),
            ),
            Text(
              '$score/100',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Nunito'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / 100,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.lightGreen),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  String _greeting(int hour) {
    if (hour < 5) return 'Assalamu Alaikum';
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    if (hour < 21) return 'Good evening';
    return 'Assalamu Alaikum';
  }
}
