/*
 * ABOUT SCREEN
 * -----------
 * Displays information about the app and its developers.
 * 
 * Key sections:
 * - App description and version information
 * - Key features and functionality overview
 * - Development team information
 * - Branding and visual identity
 * 
 * UI elements:
 * - Gradient header with app logo
 * - Developer profile cards with roles
 * - Feature list with checkmarks
 * - Visual styling consistent with app brand
 */

import 'package:flutter/material.dart';
import '../utils/color_utils.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  Widget _buildDeveloperCard({
    required String name,
    required String role,
    required String description,
    required String imageUrl,
    required List<Color> gradientColors,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ColorUtils.withAlpha10(Colors.black),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: ColorUtils.withAlpha10(Colors.black),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    name[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: gradientColors[0],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: TextStyle(
                    color: gradientColors[0],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.black54,
                    fontSize: 14,
                    height: 1.5,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF5E61F4).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF5E61F4),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.black87,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'About',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: theme.appBarTheme.titleTextStyle?.color,
            letterSpacing: 0.5,
          ),
        ),
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back_ios_rounded, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF4568DC), // Blue
                      Color(0xFF7851DF), // Purple
                      Color(0xFFB06AB3), // Pink
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: ColorUtils.withAlpha40(Colors.black),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.schedule_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Task Scheduler',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              'Version 1.0.0',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Your Professional Time Management Solution',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Task Scheduler is a powerful productivity app designed to help you organize your daily activities, prioritize tasks, and manage your time efficiently to boost productivity.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Key Features',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              _buildFeatureItem('Intuitive task management interface', isDark),
              _buildFeatureItem('Daily schedule organization', isDark),
              _buildFeatureItem('Priority-based task sorting', isDark),
              _buildFeatureItem('Deadline tracking and reminders', isDark),
              _buildFeatureItem('Customizable categories and tags', isDark),
              _buildFeatureItem('Dark mode support', isDark),
              const SizedBox(height: 30),
              Text(
                'Meet the Team',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 20),
              _buildDeveloperCard(
                name: 'Anish Chauhan',
                role: 'Developer & UI/UX Designer',
                description:
                    'Full-stack developer with expertise in creating intuitive productivity applications. Specializes in user-centered design, beautiful interfaces, and efficient task management systems to help users boost their productivity effortlessly.',
                imageUrl: '',
                gradientColors: [
                  const Color(0xFF4568DC),
                  const Color(0xFFB06AB3)
                ],
                isDark: isDark,
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  '© 2024 Task Scheduler. All rights reserved.',
                  style: TextStyle(
                    color: isDark ? Colors.grey[600] : Colors.black54,
                    fontSize: 12,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
