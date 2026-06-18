import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/project_card.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/section_header.dart';
import '../widgets/work_showcase.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final projects = PortfolioData.projects;

    Widget buildList(List<int> indices) {
      return Column(
        children: indices.asMap().entries.map((entry) {
          return StaggerReveal(
            index: entry.key,
            slideAxis: Axis.horizontal,
            child: ProjectCard(
              project: projects[entry.value],
              index: entry.value,
            ),
          );
        }).toList(),
      );
    }

    final leftIndices = [
      for (var i = 0; i < projects.length; i++)
        if (i.isEven) i,
    ];
    final rightIndices = [
      for (var i = 0; i < projects.length; i++)
        if (i.isOdd) i,
    ];

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
                  label: 'Work',
                  title: '🚀 Explore my work',
                  subtitle:
                      'Production apps shipped to Play Store, App Store, and Web.',
                  large: true,
                ),
              ),
              const SizedBox(height: 48),
              const WorkShowcase(),
              const SizedBox(height: 64),
              RevealOnScroll(
                child: Text(
                  'ALL PROJECTS',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    fontSize: 12,
                    color: AppTheme.purple,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: buildList(leftIndices)),
                    const SizedBox(width: 48),
                    Expanded(child: buildList(rightIndices)),
                  ],
                )
              else
                buildList([for (var i = 0; i < projects.length; i++) i]),
            ],
          ),
        ),
      ),
    );
  }
}
