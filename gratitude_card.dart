import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/daily_faith_record.dart';
import '../../providers/faith_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_theme.dart';

class GratitudeCard extends StatefulWidget {
  final DailyFaithRecord record;

  const GratitudeCard({super.key, required this.record});

  @override
  State<GratitudeCard> createState() => _GratitudeCardState();
}

class _GratitudeCardState extends State<GratitudeCard> {
  late TextEditingController _ctrl;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.record.gratitudeNote ?? '');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthProvider>().user?.uid ?? '';
    final faith = context.read<FaithProvider>();
    final hasNote = widget.record.gratitudeNote?.isNotEmpty ?? false;

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
              const Text('💛', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'What are you grateful for today?',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              if (!_editing)
                GestureDetector(
                  onTap: () => setState(() => _editing = true),
                  child: Icon(
                    hasNote ? Icons.edit_outlined : Icons.add_rounded,
                    color: AppColors.primaryGreen,
                    size: 20,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (_editing) ...[
            TextField(
              controller: _ctrl,
              maxLines: 3,
              autofocus: true,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                color: AppColors.textDark,
              ),
              decoration: InputDecoration(
                hintText: 'Alhamdulillah for...',
                hintStyle: TextStyle(
                  color: AppColors.textLight,
                  fontFamily: 'Nunito',
                ),
                filled: true,
                fillColor: AppColors.beige,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => setState(() => _editing = false),
                  child: Text('Cancel',
                      style: TextStyle(
                          color: AppColors.textLight, fontFamily: 'Nunito')),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    await faith.saveGratitudeNote(userId, _ctrl.text.trim());
                    setState(() => _editing = false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ] else if (hasNote) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.softGold,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                widget.record.gratitudeNote!,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  color: AppColors.textDark,
                  height: 1.5,
                ),
              ),
            ),
          ] else ...[
            GestureDetector(
              onTap: () => setState(() => _editing = true),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.beige,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.sandstone,
                      style: BorderStyle.solid),
                ),
                child: Text(
                  'Tap to add your gratitude...',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 13,
                    color: AppColors.textLight,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
