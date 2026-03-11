import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/journal_provider.dart';
import '../../models/journal_entry.dart';
import '../../utils/app_theme.dart';
import 'new_journal_entry_screen.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final journal = context.watch<JournalProvider>();
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      appBar: AppBar(title: const Text('Reflection Journal')),
      body: journal.entries.isEmpty
          ? _emptyState(context, user?.uid ?? '')
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.softGold,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Text('📖', style: TextStyle(fontSize: 24)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${journal.totalEntries} reflections written',
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                Text(
                                  'Keep reflecting — it strengthens your heart',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 12,
                                    color: AppColors.textMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final entry = journal.entries[i];
                      return _JournalEntryCard(
                        entry: entry,
                        onDelete: () => journal.deleteEntry(entry.id),
                      );
                    },
                    childCount: journal.entries.length,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NewJournalEntryScreen(userId: user?.uid ?? ''),
          ),
        ),
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.edit_rounded, color: Colors.white),
        label: const Text(
          'New Entry',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context, String userId) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('✍️', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text(
              'Begin your reflection',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '"Verily in the remembrance of Allah do hearts find rest." — Quran 13:28',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textLight,
                    fontStyle: FontStyle.italic,
                  ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NewJournalEntryScreen(userId: userId),
                ),
              ),
              child: const Text('Write First Entry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _JournalEntryCard extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback onDelete;

  const _JournalEntryCard({required this.entry, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final moodOption = MoodOption.options.firstWhere(
      (m) => m.key == entry.mood,
      orElse: () => MoodOption.options[2],
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.sandstone, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(moodOption.emoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    moodOption.label,
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    DateFormat('MMM d').format(entry.createdAt),
                    style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 12,
                        fontFamily: 'Nunito'),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _confirmDelete(context),
                    child: Icon(Icons.delete_outline,
                        size: 18, color: AppColors.textLight),
                  ),
                ],
              ),
            ],
          ),
          if (entry.prompt != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.paleGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                entry.prompt!,
                style: TextStyle(
                  color: AppColors.primaryGreen,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            entry.content,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              color: AppColors.textDark,
              height: 1.5,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete entry?'),
        content: const Text('This reflection will be permanently removed.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: Text('Delete',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
