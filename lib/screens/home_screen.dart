import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../sections/about_section.dart';
import '../sections/contact_section.dart';
import '../sections/education_section.dart';
import '../sections/lifestyle_section.dart';
import '../sections/experience_section.dart';
import '../sections/hero_section.dart';
import '../sections/projects_section.dart';
import '../sections/skills_section.dart';
import '../sections/testimonials_section.dart';
import '../theme/app_theme.dart';
import '../widgets/portfolio_nav_bar.dart';
import '../widgets/parallax_background.dart';
import '../widgets/spider_man_experience.dart';
import '../widgets/spider_man_roamer.dart';
import '../widgets/scroll_trail_effect.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/tracking_eye_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final _pointerPosition = ValueNotifier(Offset.zero);
  bool _showHireMe = false;
  final _eyeKey = GlobalKey();
  final _heroPhotoKey = GlobalKey();
  final _projectImageKey = GlobalKey();
  final _sectionKeys = <String, GlobalKey>{
    'hero': GlobalKey(),
    'about': GlobalKey(),
    'skills': GlobalKey(),
    'experience': GlobalKey(),
    'projects': GlobalKey(),
    'lifestyle': GlobalKey(),
    'testimonials': GlobalKey(),
    'contact': GlobalKey(),
  };

  void _scrollToSection(String sectionId) {
    final key = _sectionKeys[sectionId];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
        alignment: 0.05,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pointerPosition.dispose();
    super.dispose();
  }

  void _onHireMeConfirmed() {
    setState(() => _showHireMe = false);
    _scrollToSection('contact');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 768;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: PortfolioNavBar(
        onNavigate: _scrollToSection,
        isCompact: isCompact,
      ),
      body: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerHover: (event) => _pointerPosition.value = event.position,
        onPointerMove: (event) => _pointerPosition.value = event.position,
        child: Stack(
          children: [
          Positioned.fill(
            child: IgnorePointer(
              child: ParallaxBackground(scrollController: _scrollController),
            ),
          ),
          ScrollRevealScope(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  KeyedSubtree(
                    key: _sectionKeys['hero'],
                    child: HeroSection(
                      photoKey: _heroPhotoKey,
                      onExploreWork: () => _scrollToSection('projects'),
                      onContact: () => _scrollToSection('contact'),
                    ),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys['about'],
                    child: const AboutSection(),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys['skills'],
                    child: const SkillsSection(),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys['experience'],
                    child: const ExperienceSection(),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys['projects'],
                    child: ProjectsSection(featuredImageKey: _projectImageKey),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys['lifestyle'],
                    child: const LifestyleSection(),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys['testimonials'],
                    child: const TestimonialsSection(),
                  ),
                  const EducationSection(),
                  KeyedSubtree(
                    key: _sectionKeys['contact'],
                    child: const ContactSection(),
                  ),
                  _Footer(),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 16,
            child: KeyedSubtree(
              key: _eyeKey,
              child: TrackingEyeWidget(
                pointerPosition: _pointerPosition,
                pauseTracking: _showHireMe,
                onActivated: () => setState(() => _showHireMe = true),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: SpiderManExperience(
                scrollController: _scrollController,
                paused: _showHireMe,
                sectionNodes: [
                  for (final entry in _sectionKeys.entries)
                    TrailSectionNode(id: entry.key, key: entry.value),
                ],
                roamTargets: [
                  SpiderRoamTarget(
                    id: 'eye',
                    key: _eyeKey,
                    alignment: const Alignment(0, -0.35),
                    weight: 3,
                    wrapWeb: true,
                  ),
                  SpiderRoamTarget(
                    id: 'hero-photo',
                    key: _heroPhotoKey,
                    alignment: Alignment.topCenter,
                    flipFromTop: true,
                    wrapWeb: true,
                    weight: 4,
                  ),
                  SpiderRoamTarget(
                    id: 'project-image',
                    key: _projectImageKey,
                    alignment: Alignment.topCenter,
                    flipFromTop: true,
                    wrapWeb: true,
                    weight: 4,
                  ),
                  SpiderRoamTarget(
                    id: 'hero-title',
                    key: _sectionKeys['hero']!,
                    alignment: Alignment.topLeft,
                    wrapWeb: true,
                  ),
                  SpiderRoamTarget(
                    id: 'about',
                    key: _sectionKeys['about']!,
                    alignment: Alignment.topCenter,
                    wrapWeb: true,
                  ),
                  SpiderRoamTarget(
                    id: 'skills',
                    key: _sectionKeys['skills']!,
                    alignment: Alignment.centerLeft,
                    wrapWeb: true,
                  ),
                  SpiderRoamTarget(
                    id: 'experience',
                    key: _sectionKeys['experience']!,
                    alignment: Alignment.topRight,
                    wrapWeb: true,
                  ),
                  SpiderRoamTarget(
                    id: 'projects',
                    key: _sectionKeys['projects']!,
                    alignment: Alignment.topCenter,
                    wrapWeb: true,
                    weight: 2,
                  ),
                  SpiderRoamTarget(
                    id: 'lifestyle',
                    key: _sectionKeys['lifestyle']!,
                    alignment: Alignment.topLeft,
                    wrapWeb: true,
                  ),
                  SpiderRoamTarget(
                    id: 'testimonials',
                    key: _sectionKeys['testimonials']!,
                    alignment: Alignment.centerRight,
                    wrapWeb: true,
                  ),
                  SpiderRoamTarget(
                    id: 'contact',
                    key: _sectionKeys['contact']!,
                    alignment: Alignment.topCenter,
                    wrapWeb: true,
                    weight: 2,
                  ),
                ],
              ),
            ),
          ),
          if (_showHireMe)
            Positioned.fill(
              child: HireMeOverlay(onTap: _onHireMeConfirmed),
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 48),
      color: AppTheme.surfaceDark,
      child: Text(
        '© ${DateTime.now().year} ${PortfolioData.name}. Built with Flutter.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontSize: 13,
        ),
      ),
    );
  }
}
