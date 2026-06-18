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
      child: Padding(
        padding: const EdgeInsets.only(bottom: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: _buildQuote(testimonial)),
                  const SizedBox(width: 64),
                  Expanded(flex: 4, child: _buildImagePanel(images)),
                ],
              )
            else ...[
              _buildImagePanel(images, height: 240),
              const SizedBox(height: 32),
              _buildQuote(testimonial),
            ],
            const SizedBox(height: 32),
            _buildStats(testimonial),
            const Divider(color: AppTheme.border),
          ],
        ),
      ),
    );
  }

  Widget _buildQuote(Testimonial testimonial) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          testimonial.projectName,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 20,
                color: testimonial.accentColor,
              ),
        ),
        const SizedBox(height: 16),
        Text(
          '"${testimonial.quote}"',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 22,
                height: 1.55,
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w400,
              ),
        ),
        const SizedBox(height: 24),
        Text(
          testimonial.author,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 16,
              ),
        ),
        Text(
          testimonial.role,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textMuted,
                fontSize: 13,
              ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
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
    return Row(
      children: testimonial.stats.asMap().entries.map((entry) {
        final isLast = entry.key == testimonial.stats.length - 1;
        return Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              border: Border(
                right: isLast
                    ? BorderSide.none
                    : const BorderSide(color: AppTheme.border),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
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
        height: height ?? 320,
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
                left: 12,
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
                right: 12,
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
                  fontWeight: FontWeight.w500,
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
      color: Colors.black45,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
