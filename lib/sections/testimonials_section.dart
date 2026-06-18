import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/section_header.dart';
import '../widgets/testimonial_card.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RevealOnScroll(
                child: const SectionHeader(
                  label: 'Testimonials',
                  title: '💬 What clients say',
                  subtitle:
                      'Production apps shipped and trusted by real businesses.',
                  large: true,
                ),
              ),
              const SizedBox(height: 56),
              ...PortfolioData.testimonials.asMap().entries.map(
                    (entry) => StaggerReveal(
                      index: entry.key,
                      child: TestimonialCard(testimonial: entry.value),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
