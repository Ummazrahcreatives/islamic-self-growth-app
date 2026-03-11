import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.primaryGreen,
                    child: Text(
                      (user?.displayName ?? 'M')[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    user?.displayName ?? 'Muslim',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    user?.email ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.textLight),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.softGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '🌿 Growing Muslim',
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Menu items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _MenuSection(
                    title: 'App',
                    items: [
                      _MenuItem(
                        icon: Icons.notifications_outlined,
                        label: 'Notifications',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.palette_outlined,
                        label: 'Appearance',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.language_outlined,
                        label: 'Language',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _MenuSection(
                    title: 'Support',
                    items: [
                      _MenuItem(
                        icon: Icons.help_outline,
                        label: 'Help & FAQ',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.star_outline,
                        label: 'Rate the App',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _MenuSection(
                    title: 'Account',
                    items: [
                      _MenuItem(
                        icon: Icons.logout_rounded,
                        label: 'Sign Out',
                        isDestructive: true,
                        onTap: () => _confirmSignOut(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            Text(
              'Nūr — Islamic Growth v1.0.0',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 16,
                color: AppColors.primaryGreen.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text(
            'Are you sure you want to sign out? Your progress is safely saved.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthProvider>().signOut();
            },
            child: Text('Sign Out',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;

  const _MenuSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textLight,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.sandstone),
          ),
          child: Column(
            children: items.asMap().entries.map((e) {
              final isLast = e.key == items.length - 1;
              return Column(
                children: [
                  e.value,
                  if (!isLast)
                    Divider(
                        height: 1,
                        indent: 52,
                        color: AppColors.sandstone),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : AppColors.textMedium;
    return ListTile(
      dense: true,
      leading: Icon(icon, color: color, size: 20),
      title: Text(
        label,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: AppColors.textLight, size: 18),
      onTap: onTap,
    );
  }
}
