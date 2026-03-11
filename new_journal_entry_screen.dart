import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/journal_provider.dart';
import '../../models/journal_entry.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common/primary_button.dart';
import 'dart:math';

class NewJournalEntryScreen extends StatefulWidget {
  final String userId;
  const NewJournalEntryScreen({super.key, required this.userId});

  @override
  State<NewJournalEntryScreen> createState() => _NewJournalEntryScreenState();
}

class _NewJournalEntryScreenState extends State<NewJournalEntryScreen> {
  final _contentCtrl = TextEditingController();
  String _selectedMood = 'content';
  String? _selectedPrompt;
  bool _usePrompt = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedPrompt = AppConstants.journalPrompts[
        Random().nextInt(AppConstants.journalPrompts.length)];
  }

  @override
  void dispose() {
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_contentCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something first')),
      );
      return;
    }
    setState(() => _isSaving = true);
    await context.read<JournalProvider>().addEntry(
      userId: widget.userId,
      content: _contentCtrl.text.trim(),
      prompt: _usePrompt ? _selectedPrompt : null,
      mood: _selectedMood,
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      appBar: AppBar(
        title: const Text('New Reflection'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: _isSaving ? null : _save,
              child: Text(
                'Save',
                style: TextStyle(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Nunito',
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mood selector
            Text('How are you feeling?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 15)),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: MoodOption.options.map((mood) {
                  final selected = _selectedMood == mood.key;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedMood = mood.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primaryGreen
                            : AppColors.beige,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? AppColors.primaryGreen
                              : AppColors.sandstone,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(mood.emoji, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(
                            mood.label,
                            style: TextStyle(
                              color: selected ? Colors.white : AppColors.textMedium,
                              fontSize: 13,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Prompt toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Use guided prompt',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 15)),
                Switch(
                  value: _usePrompt,
                  activeColor: AppColors.primaryGreen,
                  onChanged: (v) => setState(() => _usePrompt = v),
                ),
              ],
            ),
            if (_usePrompt) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.paleGreen,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.lightGreen.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      _selectedPrompt ?? '',
                      style: const TextStyle(
                        color: AppColors.primaryGreen,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Nunito',
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => setState(() {
                        final prompts = AppConstants.journalPrompts;
                        _selectedPrompt =
                            prompts[Random().nextInt(prompts.length)];
                      }),
                      child: Text(
                        '↻ New prompt',
                        style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),

            // Text area
            Text('Your reflection',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 15)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.sandstone),
              ),
              child: TextField(
                controller: _contentCtrl,
                maxLines: 12,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 15,
                  color: AppColors.textDark,
                  height: 1.6,
                ),
                decoration: InputDecoration(
                  hintText:
                      'Write freely... this is your private space with Allah as your witness.',
                  hintStyle: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 14,
                    fontFamily: 'Nunito',
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Save Reflection',
              onPressed: _save,
              isLoading: _isSaving,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
