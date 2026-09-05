import 'package:flutter/material.dart';
import '../models/portfolio_models.dart';
import '../theme/app_theme.dart';
import '../utils/url_helper.dart';
import '../widgets/hover_card.dart';

class TestimonialCard extends StatefulWidget {
  const TestimonialCard({super.key, required this.testimonial});

  final Testimonial testimonial;

  @override
  State<TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<TestimonialCard> {
  int _imageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final testimonial = widget.testimonial;
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final images = testimonial.imageAssets;

    return HoverCard(
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.border),
          boxShadow: [
            BoxShadow(
              color: testimonial.accentColor.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top accent indicator bar
            Container(
              height: 4,
              width: double.infinity,
              color: testimonial.accentColor,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isWide ? 36 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: _buildQuote(testimonial),
                                  ),
                                ),
                                const SizedBox(width: 40),
                                Expanded(
                                  flex: 4,
                                  child: _buildImagePanel(images),
                                ),
                              ],
                            )
                          : SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildImagePanel(images, height: 200),
                                  const SizedBox(height: 20),
                                  _buildQuote(testimonial),
                                ],
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                    _buildStats(testimonial),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuote(Testimonial testimonial) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: testimonial.accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                testimonial.projectName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: testimonial.accentColor,
                    ),
              ),
            ),
            const Spacer(),
            Icon(
              Icons.format_quote_rounded,
              size: 32,
              color: testimonial.accentColor.withValues(alpha: 0.25),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          '"${testimonial.quote}"',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                height: 1.55,
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w400,
              ),
        ),
        const SizedBox(height: 18),
        Text(
          testimonial.author,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
        ),
        Text(
          testimonial.role,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textMuted,
                fontSize: 13,
              ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            if (testimonial.websiteUrl != null)
              _ActionLink(
                label: 'Visit Website',
                onTap: () => launchExternalUrl(testimonial.websiteUrl!),
              ),
            if (testimonial.playStoreUrl != null)
              _ActionLink(
                label: 'Play Store',
                onTap: () => launchExternalUrl(testimonial.playStoreUrl!),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildStats(Testimonial testimonial) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: testimonial.stats.map((stat) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: testimonial.accentColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: testimonial.accentColor.withValues(alpha: 0.25),
            ),
          ),
          child: Text(
            stat,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildImagePanel(List<String> images, {double? height}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: height ?? double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Image.asset(
                images[_imageIndex],
                key: ValueKey(images[_imageIndex]),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppTheme.backgroundAlt,
                  child: Icon(
                    Icons.image_outlined,
                    size: 48,
                    color: widget.testimonial.accentColor.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
            if (images.length > 1) ...[
              Positioned(
                left: 10,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _NavButton(
                    icon: Icons.chevron_left,
                    onTap: () => setState(
                      () => _imageIndex =
                          (_imageIndex - 1 + images.length) % images.length,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _NavButton(
                    icon: Icons.chevron_right,
                    onTap: () => setState(
                      () => _imageIndex = (_imageIndex + 1) % images.length,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionLink extends StatelessWidget {
  const _ActionLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_outward, size: 14),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

