import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_stat_counter.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/section_header.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Container(
      width: double.infinity,
      color: AppTheme.white,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 48 : 24,
        vertical: isWide ? 100 : 64,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: RevealOnScroll(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  label: 'About Me',
                  title: 'Turning ideas into\nproduction apps. 👋',
                  large: true,
                ),
                const SizedBox(height: 40),
                isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(flex: 3, child: _HighlightedAboutText()),
                          const SizedBox(width: 48),
                          const Expanded(flex: 2, child: _StatsGrid()),
                        ],
                      )
                    : const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _HighlightedAboutText(),
                          SizedBox(height: 40),
                          _StatsGrid(),
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

class _HighlightedAboutText extends StatelessWidget {
  const _HighlightedAboutText();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    const baseStyle = TextStyle(
      fontSize: 18,
      height: 1.7,
      color: AppTheme.textSecondary,
      fontWeight: FontWeight.w400,
    );
    const highlightStyle = TextStyle(
      fontSize: 18,
      height: 1.7,
      color: AppTheme.purple,
      fontWeight: FontWeight.w800,
      decoration: TextDecoration.underline,
      decorationColor: AppTheme.purple,
      decorationThickness: 2,
    );
    const boldStyle = TextStyle(
      fontSize: 18,
      height: 1.7,
      color: AppTheme.black,
      fontWeight: FontWeight.w700,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            style: baseStyle,
            children: [
              TextSpan(text: 'Flutter Developer with '),
              TextSpan(text: '2+ YEARS OF EXPERIENCE', style: highlightStyle),
              TextSpan(text: ' building scalable applications for '),
              TextSpan(text: 'ANDROID, iOS & WEAR OS', style: highlightStyle),
              TextSpan(
                text:
                    '. Shipped over 150+ apps to Google Play Store and 50+ to Apple App Store adhering to clean architecture, Firebase, and REST APIs.',
              ),
            ],
          ),
        ),
        if (isWide) ...[
          const SizedBox(height: 20),
          RichText(
            text: const TextSpan(
              style: baseStyle,
              children: [
                TextSpan(text: 'Specialized in modern state management ('),
                TextSpan(text: 'Provider, GetX, Riverpod, Bloc', style: boldStyle),
                TextSpan(text: '), payment gateways ('),
                TextSpan(text: 'Razorpay, Stripe', style: boldStyle),
                TextSpan(text: '), real-time video/audio calling ('),
                TextSpan(text: 'Agora SDK, Twilio', style: boldStyle),
                TextSpan(
                  text:
                      '), and automated push notifications with Firebase FCM. Dedicated to writing clean, maintainable code with high performance across all mobile and wearable screen sizes.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          RichText(
            text: const TextSpan(
              style: baseStyle,
              children: [
                TextSpan(text: 'Experienced in delivering multi-app ecosystems including '),
                TextSpan(text: 'Zofanso', style: boldStyle),
                TextSpan(text: ' (4.8★ on Play Store with 5K+ downloads), '),
                TextSpan(text: 'Erizo Grocery & Delivery Partner Apps', style: boldStyle),
                TextSpan(text: ', Wear OS smartwatch trackers ('),
                TextSpan(text: 'Padel Magic', style: boldStyle),
                TextSpan(
                  text:
                      '), and enterprise backends with Java & Spring Boot.',
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: PortfolioData.stats.asMap().entries.map((entry) {
        final stat = entry.value;
        return StaggerReveal(
          index: entry.key,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(24),
            decoration: AppTheme.cardDecoration(),
            child: Row(
              children: [
                AnimatedStatCounter(
                  value: stat.$1,
                  delay: Duration(milliseconds: entry.key * 150),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 44,
                        color: AppTheme.purple,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    stat.$2.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

