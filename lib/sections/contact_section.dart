import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../utils/url_helper.dart';
import '../widgets/reveal_on_scroll.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final contact = PortfolioData.contact;

    return Container(
      width: double.infinity,
      color: AppTheme.black,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 48 : 24,
        vertical: isWide ? 120 : 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: RevealOnScroll(
            child: Column(
              children: [
                Text(
                  "LET'S WORK\nTOGETHER",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: isWide ? 72 : 44,
                        color: AppTheme.white,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Open to Flutter roles, freelance projects, and collaborations.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.white.withValues(alpha: 0.6),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 48),
                InkWell(
                  onTap: () => launchEmail(contact.email),
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: AppTheme.neon,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: AppTheme.black,
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(height: 56),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 32,
                  runSpacing: 16,
                  children: [
                    _ContactChip(
                      label: contact.email,
                      onTap: () => launchEmail(contact.email),
                    ),
                    _ContactChip(
                      label: contact.phone,
                      onTap: () => launchPhone(contact.phone),
                    ),
                    _ContactChip(
                      label: 'GitHub',
                      onTap: () => launchExternalUrl(contact.githubUrl),
                    ),
                    _ContactChip(
                      label: 'LinkedIn',
                      onTap: () => launchExternalUrl(contact.linkedinUrl),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactChip extends StatelessWidget {
  const _ContactChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.white.withValues(alpha: 0.25)),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppTheme.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
