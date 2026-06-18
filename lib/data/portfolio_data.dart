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

  static const String profilePhoto = 'assets/images/img-4.jpeg';
  static const String officePhoto = 'assets/images/img-1.jpeg';
  static const String teamPhoto = 'assets/images/img-2.jpeg';

  static const List<MediaAsset> workMedia = [
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
      path: 'assets/images/erizo_promo.png',
      type: MediaType.image,
      title: 'Erizo App',
      subtitle: 'Multivendor grocery platform',
      projectTag: 'Erizo',
    ),
    MediaAsset(
      path: 'assets/images/erizo_play_console.png',
      type: MediaType.image,
      title: 'Play Console',
      subtitle: '3 apps in production',
      projectTag: 'Erizo',
    ),
    MediaAsset(
      path: 'assets/images/erizo_web_home.png',
      type: MediaType.image,
      title: 'Erizo Web',
      subtitle: 'erizo.in storefront',
      projectTag: 'Erizo',
    ),
    MediaAsset(
      path: 'assets/images/zofanso_play_store.png',
      type: MediaType.image,
      title: 'Zofanso',
      subtitle: '4.8★ · 5K+ downloads',
      projectTag: 'Zofanso',
    ),
  ];

  static const List<MediaAsset> lifestyleMedia = [
    MediaAsset(
      path: 'assets/images/img-4.jpeg',
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
        'Flutter',
        'Dart',
        'Android & iOS & Wear OS',
        'REST API Integration',
        'Firebase',
      ],
    ),
    SkillCategory(
      title: 'State Management',
      skills: ['Provider', 'GetX', 'Riverpod (familiar)'],
    ),
    SkillCategory(
      title: 'Integrations',
      skills: [
        'Payment Gateways',
        'Firebase Cloud Messaging',
        'Twilio',
        'Agora SDK',
        'Push Notifications',
      ],
    ),
    SkillCategory(
      title: 'Deployment',
      skills: [
        'Google Play Store',
        'Apple App Store',
        'Production Release Management',
      ],
    ),
    SkillCategory(
      title: 'Tools',
      skills: ['Git', 'GitHub', 'Android Studio', 'VS Code', 'Postman'],
    ),
    SkillCategory(
      title: 'Other',
      skills: ['Java'],
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
      name: 'Zofanso',
      techStack: ['Flutter', 'Dart', 'Firebase', 'Laravel'],
      description:
          'Multivendor food & grocery delivery app — 4.8★ on Play Store with 5K+ downloads.',
      highlights: [
        'Order scheduling, live chat support, and refer & earn system.',
        'Location-based delivery, payment gateway, and Firebase integration.',
      ],
      websiteUrl: 'https://zofanso.com',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=com.frantic.safemax.user',
      coverImage: 'assets/images/zofanso_play_store.png',
    ),
    Project(
      name: 'Erizo',
      techStack: ['Flutter', 'Dart', 'Firebase', 'Laravel'],
      description:
          'Customer grocery app — part of the Erizo ecosystem with web platform at erizo.in.',
      highlights: [
        'Product catalog, cart, checkout, and in-store pickup.',
        'Live order tracking with Firebase and REST APIs.',
      ],
      websiteUrl: 'https://erizo.in',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=com.erizo.user',
      coverImage: 'assets/images/erizo_promo.png',
    ),
    Project(
      name: 'Erizo Delivery',
      techStack: ['Flutter', 'Dart', 'Firebase', 'Maps'],
      description:
          'Delivery partner app for the Erizo grocery ecosystem — live on Google Play Store.',
      highlights: [
        'Real-time order assignment, pickup, and drop-off tracking on map.',
        'Production app (com.erizo.delivery) integrated with vendor & customer apps.',
      ],
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=com.erizo.delivery',
      coverImage: 'assets/images/erizo_web_home.png',
    ),
    Project(
      name: 'Padel Magic',
      techStack: ['Flutter', 'Dart', 'Wear OS'],
      description:
          'Wear OS smartwatch application for Padel sport tracking, published on Google Play Store.',
      highlights: [
        'Optimized UI for small watch displays.',
        'Real-time data and smooth Wear OS interactions.',
      ],
      playStoreUrl:
          'https://play.google.com/store/search?q=padel+magic&c=apps',
    ),
    Project(
      name: 'Astrology Consultation App',
      techStack: [
        'Flutter',
        'Dart',
        'Firebase',
        'Twilio',
        'Agora SDK',
        'Payment Gateway',
      ],
      description:
          'Real-time consultation platform with audio/video calling and payment gateway integration.',
      highlights: [
        'Appointment booking, live chat, and horoscope features.',
        'Twilio OTP, Agora SDK calls, and Firebase push notifications.',
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
