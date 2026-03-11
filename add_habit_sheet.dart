import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/habits_provider.dart';
import '../../utils/app_theme.dart';

class AddHabitSheet extends StatefulWidget {
  final String userId;
  const AddHabitSheet({super.key, required this.userId});

  @override
  State<AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends State<AddHabitSheet> {
  final _nameCtrl = TextEditingController();
  String _selectedCategory = 'Spiritual';
  String _selectedIcon = '⭐';
  bool _isSaving = false;

  final List<String> _icons = [
    '⭐', '🌙', '📖', '🤲', '🕌', '💪', '🏃', '📚',
    '💛', '🌱', '🤝', '💰', '🧘', '✍️', '🌿', '🔢',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) return;
    setState(() => _isSaving = true);
    await context.read<HabitsProvider>().addHabit(
      userId: widget.userId,
      name: _nameCtrl.text.trim(),
      category: _selectedCategory,
      icon: _selectedIcon,
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.sandstone,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Add New Habit',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 20),
              TextField(
                controller: _nameCtrl,
                autofocus: true,
                style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 15,
                    color: AppColors.textDark),
                decoration: InputDecoration(
                  hintText: 'e.g., Read Quran after Fajr',
                  hintStyle:
                      TextStyle(color: AppColors.textLight, fontFamily: 'Nunito'),
                  filled: true,
                  fillColor: AppColors.beige,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),
              Text('Category',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: AppConstants.habitCategories.map((cat) {
                    final selected = _selectedCategory == cat;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
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
                                  : AppColors.sandstone),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? Colors.white
                                : AppColors.textMedium,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              Text('Icon',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _icons.map((icon) {
                  final selected = _selectedIcon == icon;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = icon),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color:
                            selected ? AppColors.primaryGreen : AppColors.beige,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: selected
                                ? AppColors.primaryGreen
                                : AppColors.sandstone),
                      ),
                      child: Center(
                        child:
                            Text(icon, style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      : const Text(
                          'Add Habit',
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
