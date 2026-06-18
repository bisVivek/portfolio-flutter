import 'package:flutter/material.dart';

class SkillCategory {
  const SkillCategory({required this.title, required this.skills});

  final String title;
  final List<String> skills;
}

class Experience {
  const Experience({
    required this.title,
    required this.company,
    required this.period,
    required this.highlights,
    this.location,
  });

  final String title;
  final String company;
  final String period;
  final String? location;
  final List<String> highlights;
}

class Project {
  const Project({
    required this.name,
    required this.techStack,
    required this.description,
    required this.highlights,
    this.coverImage,
    this.websiteUrl,
    this.playStoreUrl,
    this.appStoreUrl,
  });

  final String name;
  final List<String> techStack;
  final String description;
  final List<String> highlights;
  final String? coverImage;
  final String? websiteUrl;
  final String? playStoreUrl;
  final String? appStoreUrl;
}

class Education {
  const Education({
    required this.degree,
    required this.institution,
    required this.period,
    this.cgpa,
  });

  final String degree;
  final String institution;
  final String period;
  final String? cgpa;
}

class ContactInfo {
  const ContactInfo({
    required this.email,
    required this.phone,
    required this.githubUrl,
    required this.linkedinUrl,
  });

  final String email;
  final String phone;
  final String githubUrl;
  final String linkedinUrl;
}

class Testimonial {
  const Testimonial({
    required this.projectName,
    required this.quote,
    required this.author,
    required this.role,
    required this.stats,
    required this.imageAssets,
    required this.accentColor,
    this.websiteUrl,
    this.playStoreUrl,
  });

  final String projectName;
  final String quote;
  final String author;
  final String role;
  final List<String> stats;
  final List<String> imageAssets;
  final Color accentColor;
  final String? websiteUrl;
  final String? playStoreUrl;
}

enum MediaType { image, video }

class MediaAsset {
  const MediaAsset({
    required this.path,
    required this.type,
    required this.title,
    this.subtitle,
    this.projectTag,
  });

  final String path;
  final MediaType type;
  final String title;
  final String? subtitle;
  final String? projectTag;
}
