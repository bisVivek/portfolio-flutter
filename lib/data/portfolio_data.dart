import 'package:flutter/material.dart';
import '../models/portfolio_models.dart';

/// Central portfolio content — update links here before deploying.
class PortfolioData {
  static const String name = 'Vivek Bisht';
  static const String title = 'Flutter Developer';
  static const String summary =
      'Flutter Developer with 2+ years of experience building high-performance, '
      'scalable Android, iOS, and Wear OS applications using Flutter, Dart, '
      'Firebase, and REST APIs. Shipped 150+ apps to Google Play Store and 50+ '
      'to Apple App Store. Proven expertise in payment gateway integration, '
      'state management (Provider, GetX), production release management, '
      'and clean architecture. Strong UI/UX sensibility with a track record of '
      'delivering production-ready cross-platform apps.';

  static const ContactInfo contact = ContactInfo(
    email: 'vivek5832017@gmail.com',
    phone: '+91 8171522213',
    githubUrl: 'https://github.com/bisVivek',
    linkedinUrl: 'https://www.linkedin.com/in/vivek-bisht-5832017vb/',
  );

  static const List<(String, String)> stats = [
    ('2+', 'Years Experience'),
    ('150+', 'Play Store Apps'),
    ('50+', 'App Store Apps'),
    ('3', 'Platforms'),
  ];

  static const String profilePhoto = 'assets/images/img-5.jpeg';
  static const String officePhoto = 'assets/images/img-1.jpeg';
  static const String teamPhoto = 'assets/images/img-2.jpeg';

  static const List<MediaAsset> workMedia = [
    MediaAsset(
      path: 'assets/videoes/pvb.mp4',
      type: MediaType.video,
      title: 'Featured Reel',
      subtitle: 'Portfolio background & video showcase',
      projectTag: 'Portfolio',
    ),
    MediaAsset(
      path: 'assets/videoes/vid-1.mp4',
      type: MediaType.video,
      title: 'App Demo',
      subtitle: 'Flutter project walkthrough',
      projectTag: 'Zofanso',
    ),
    MediaAsset(
      path: 'assets/videoes/vid-2.mp4',
      type: MediaType.video,
      title: 'App Demo',
      subtitle: 'Production app showcase',
      projectTag: 'Erizo',
    ),
    MediaAsset(
      path: 'assets/images/screenshot_1_erizo.png',
      type: MediaType.image,
      title: 'Erizo Commerce',
      subtitle: 'Multivendor grocery platform',
      projectTag: 'Erizo',
    ),
    MediaAsset(
      path: 'assets/images/screenshot_2_zofanso.png',
      type: MediaType.image,
      title: 'Zofanso Marketplace',
      subtitle: '4.8★ · 5K+ downloads',
      projectTag: 'Zofanso',
    ),
    MediaAsset(
      path: 'assets/images/scsreenshot_2_erizo.png',
      type: MediaType.image,
      title: 'Erizo Delivery',
      subtitle: 'GPS Map & Navigation app',
      projectTag: 'Erizo Delivery',
    ),
  ];

  static const List<MediaAsset> lifestyleMedia = [
    MediaAsset(
      path: 'assets/images/img-5.jpeg',
      type: MediaType.image,
      title: 'Portrait',
      subtitle: 'Flutter Developer · Dehradun',
    ),
    MediaAsset(
      path: 'assets/images/img-1.jpeg',
      type: MediaType.image,
      title: 'At Work',
      subtitle: 'Pearl Organisation · Dehradun',
    ),
    MediaAsset(
      path: 'assets/images/img-2.jpeg',
      type: MediaType.image,
      title: 'The Team',
      subtitle: 'Building apps together',
    ),
    MediaAsset(
      path: 'assets/images/img-3.jpeg',
      type: MediaType.image,
      title: 'Beyond Code',
      subtitle: 'Travel & exploration',
    ),
  ];

  static const List<SkillCategory> skillCategories = [
    SkillCategory(
      title: 'Core',
      skills: [
        'Flutter SDK',
        'Dart Language',
        'Android, iOS & Wear OS',
        'Clean Architecture',
        'REST API Integration',
        'Firebase Backend',
        'Responsive UI/UX',
      ],
    ),
    SkillCategory(
      title: 'State Management',
      skills: [
        'Provider',
        'GetX Pattern',
        'Riverpod',
        'Bloc / Cubit',
        'Dependency Injection (GetIt)',
        'MVVM & Clean Code',
      ],
    ),
    SkillCategory(
      title: 'Backend & Languages',
      skills: [
        'Java Enterprise',
        'Spring Boot Framework',
        'RESTful API Design',
        'Dart',
        'SQL & Firestore DB',
        'Microservices Architecture',
      ],
    ),
    SkillCategory(
      title: 'Integrations',
      skills: [
        'Razorpay & Stripe Gateways',
        'Firebase Cloud Messaging (FCM)',
        'Twilio OTP & SMS',
        'Agora Audio/Video SDK',
        'Google Maps & Location Services',
        'Social Auth & OAuth 2.0',
      ],
    ),
    SkillCategory(
      title: 'Deployment',
      skills: [
        'Google Play Console (150+ Apps)',
        'Apple App Store Connect (50+ Apps)',
        'Production Release Cycles',
        'CI/CD Pipelines',
        'Fastlane Automation',
        'TestFlight & Beta Testing',
      ],
    ),
    SkillCategory(
      title: 'Tools',
      skills: [
        'Git & GitHub Workflows',
        'Android Studio & Xcode',
        'Postman API Testing',
        'VS Code',
        'Figma UI Design to Code',
        'Wear OS Emulators',
      ],
    ),
  ];

  static const List<Experience> experiences = [
    Experience(
      title: 'Flutter Developer',
      company: 'Pearl Organisation',
      period: 'Present',
      highlights: [
        'Building cross-platform Android and iOS apps using Flutter and Dart with clean architecture.',
        'Shipped 150+ applications to Google Play Store and 50+ to Apple App Store.',
        'Integrating REST APIs, Firebase Auth, Firestore, and Firebase Cloud Messaging.',
        'Managing production release cycles, reusable widgets, and performance optimizations.',
      ],
    ),
    Experience(
      title: 'Flutter Developer',
      company: 'Ftechiz Solutions Pvt. Ltd.',
      period: 'Sep 2024 – Oct 2025',
      location: 'Dehradun',
      highlights: [
        'Developed Flutter apps for Android, iOS, and Web with scalable architecture.',
        'Integrated RESTful APIs, Firebase Auth, Firestore, and push notifications.',
        'Built e-commerce and service-based apps; deployed on Play Store and App Store.',
      ],
    ),
  ];

  static const List<Project> projects = [
    Project(
      name: 'ERIZO',
      subtitle: 'MULTIVENDOR COMMERCE PLATFORM',
      techStack: ['Flutter', 'Dart', 'Firebase', 'Laravel'],
      description:
          'Customer grocery app & web storefront platform with real-time order processing.',
      highlights: [
        'Product catalog & cart checkout',
        'Live order tracking with Firebase',
        'Storefront web platform at erizo.in',
      ],
      websiteUrl: 'https://erizo.in',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=com.erizo.user',
      coverImage: 'assets/images/erizo_project_image.jpeg',
      additionalImages: [
        'assets/images/screenshot_1_erizo.png',
        'assets/images/scsreenshot_2_erizo.png',
        'assets/images/erizo_web_home.png',
      ],
    ),
    Project(
      name: 'ZOFANSO',
      subtitle: 'FOOD • GROCERY • MULTIVENDOR',
      techStack: ['Flutter', 'Dart', 'Firebase', 'Laravel'],
      description:
          'Production-ready marketplace application built for real-world commerce with 5K+ downloads.',
      highlights: [
        'Multi-vendor food & grocery architecture',
        'Real-time order management & live chat',
        '4.8★ on Play Store with 110+ reviews',
      ],
      websiteUrl: 'https://zofanso.com',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=com.frantic.safemax.user',
      coverImage: 'assets/images/zofanso_project_image.png',
      additionalImages: [
        'assets/images/screenshot_2_zofanso.png',
        'assets/images/zofanso_portfolio_banner.png',
      ],
    ),
    Project(
      name: 'ERIZO DELIVERY',
      subtitle: 'DELIVERY & MAP NAVIGATION',
      techStack: ['Flutter', 'Dart', 'Firebase', 'Google Maps'],
      description:
          'Delivery partner app for live order navigation, GPS location tracking, and order assignment.',
      highlights: [
        'Real-time GPS location tracking & map route',
        'Live map navigation for delivery partners',
        'Production release live on Google Play Store',
      ],
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=com.erizo.delivery',
      coverImage: 'assets/images/erizo_Delivery_project_image.png',
      additionalImages: [
        'assets/images/scsreenshot_2_erizo.png',
        'assets/images/erizo_play_console.png',
      ],
    ),
    Project(
      name: 'PADEL MAGIC',
      subtitle: 'WEAR OS SPORT TRACKER',
      techStack: ['Flutter', 'Dart', 'Wear OS'],
      description:
          'Wear OS smartwatch application for Padel sport tracking, published on Google Play Store.',
      highlights: [
        'Optimized UI for round watch displays',
        'Low-latency touch & wrist gestures',
        'Published live on Google Play Store',
      ],
      playStoreUrl:
          'https://play.google.com/store/search?q=padel+magic&c=apps',
      coverImage: 'assets/images/padel_watch_project.png',
      additionalImages: [
        'assets/images/screenshot_padelwatch.png',
        'assets/images/PADEL_MAGIC_banner.png',
      ],
    ),
    Project(
      name: 'ASTROLOGY',
      subtitle: 'REAL-TIME AUDIO + VIDEO',
      techStack: [
        'Flutter',
        'Agora',
        'Twilio',
        'Firebase',
        'Payment Gateway',
      ],
      description:
          'Real-time consultation platform with high-definition audio/video calling and payment gateway.',
      highlights: [
        'HD video/audio via Agora SDK',
        'Twilio OTP authentication',
        'In-app wallet & consultation booking',
      ],
      coverImage: 'assets/images/astro_project_image.jpeg',
      additionalImages: [
        'assets/images/img-3.jpeg',
        'assets/images/img-4.jpeg',
      ],
    ),
  ];

  static const List<Testimonial> testimonials = [
    Testimonial(
      projectName: 'Erizo',
      quote:
          'Vivek built our entire grocery delivery ecosystem from the ground up — '
          'customer app, vendor panel, and Erizo Delivery app — all live on Play Store. '
          'The platform handles real-time order tracking, in-store pickup, live map '
          'navigation for delivery partners, and a full web storefront at erizo.in. '
          'His Flutter expertise made Erizo production-ready across Android, iOS, and Web.',
      author: 'Erizo Team',
      role: 'Grocery & Essentials Platform · erizo.in',
      stats: [
        'Erizo Delivery Live',
        '3 Play Store Apps',
        'Production Ready',
        'Real-time Tracking',
      ],
      imageAssets: [
        'assets/images/erizo_promo.png',
        'assets/images/erizo_play_console.png',
        'assets/images/erizo_web_home.png',
      ],
      accentColor: Color(0xFF7B61FF),
      websiteUrl: 'https://erizo.in',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=com.erizo.delivery',
    ),
    Testimonial(
      projectName: 'Zofanso',
      quote:
          'Vivek delivered a polished multivendor food and grocery platform that '
          'our users love. The app ships with order scheduling, live chat support, '
          'refer & earn, and seamless payment flows. It earned 4.8★ on Play Store '
          'with 5,000+ downloads — a testament to the quality and performance he '
          'brought to every screen.',
      author: 'Safemaxx Deliv Technologies',
      role: 'Food & Grocery Delivery · zofanso.com',
      stats: [
        '4.8★ Rating',
        '5K+ Downloads',
        '110+ Reviews',
        'Play Store Live',
      ],
      imageAssets: [
        'assets/images/zofanso_play_store.png',
      ],
      accentColor: Color(0xFFC1FF00),
      websiteUrl: 'https://zofanso.com',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=com.frantic.safemax.user',
    ),
  ];

  static const List<Education> education = [
    Education(
      degree: 'Master of Computer Applications (MCA)',
      institution: 'Uttaranchal University',
      period: '2022–2024',
      cgpa: '8.4/10',
    ),
    Education(
      degree: 'Bachelor of Science (B.Sc.)',
      institution: 'SGRR University',
      period: '2020–2022',
    ),
  ];
}
