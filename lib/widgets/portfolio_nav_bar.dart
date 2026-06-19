import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';

class PortfolioNavBar extends StatelessWidget implements PreferredSizeWidget {
  const PortfolioNavBar({
    super.key,
    required this.onNavigate,
    required this.isCompact,
  });

  final void Function(String sectionId) onNavigate;
  final bool isCompact;

  static const _items = [
    ('Work', 'projects'),
    ('Lifestyle', 'lifestyle'),
    ('Skills', 'skills'),
    ('About', 'about'),
    ('Experience', 'experience'),
  ];

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.black,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 20 : 48,
            vertical: 16,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => onNavigate('hero'),
                child: Text(
                  PortfolioData.name.split(' ').first.toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    fontSize: 15,
                  ),
                ),
              ),
              const Spacer(),
              if (!isCompact)
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Row(
                      children: [
                        _NeonContactBtn(onTap: () => onNavigate('contact')),
                        ..._items.reversed.map(
                          (item) => TextButton(
                            onPressed: () => onNavigate(item.$2),
                            child: Text(
                              item.$1,
                              style: const TextStyle(
                                color: AppTheme.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                PopupMenuButton<String>(
                  icon: const Icon(Icons.menu, color: AppTheme.white),
                  color: AppTheme.black,
                  onSelected: onNavigate,
                  itemBuilder: (context) => [
                    ..._items.map(
                      (item) => PopupMenuItem(
                        value: item.$2,
                        child: Text(item.$1, style: const TextStyle(color: AppTheme.white)),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'contact',
                      child: Text('Contact', style: TextStyle(color: AppTheme.white)),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NeonContactBtn extends StatelessWidget {
  const _NeonContactBtn({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        child: const Text('CONTACT ME'),
      ),
    );
  }
}
