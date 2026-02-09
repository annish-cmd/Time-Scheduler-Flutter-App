/*
 * HELP & SUPPORT SCREEN
 * -------------------
 * Provides support resources and contact information.
 * 
 * Key features:
 * - Social media links for support
 * - Contact information
 * - FAQ section for common questions
 * - External link handling with url_launcher
 * 
 * UI elements:
 * - Gradient header with support icon
 * - Social media cards with icons
 * - Email and contact links
 * - Visual styling consistent with app brand
 */

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import '../utils/color_utils.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await url_launcher.launchUrl(uri,
        mode: url_launcher.LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
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
        title: const Text(
          'Help & Support',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
                      color: ColorUtils.withAlpha10(Colors.black),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.support_agent_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Need Help?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'We\'re here to help you manage your time effectively',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Contact & Social Links',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 20),
              _buildSocialLink(
                title: 'GitHub',
                subtitle: '@annish-cmd',
                icon: Icons.code_rounded,
                onTap: () => _launchUrl('https://github.com/annish-cmd/'),
                gradientColors: [
                  const Color(0xFF6e5494), // GitHub purple
                  const Color(0xFF24292e), // GitHub dark
                ],
                isDark: isDark,
              ),
              _buildSocialLink(
                title: 'LinkedIn',
                subtitle: '@anishchauhan25',
                icon: Icons.work_rounded,
                onTap: () =>
                    _launchUrl('https://www.linkedin.com/in/anishchauhan25/'),
                gradientColors: [
                  const Color(0xFF0077B5),
                  const Color(0xFF00A0DC),
                ],
                isDark: isDark,
              ),
              _buildSocialLink(
                title: 'Website',
                subtitle: 'www.anishchauhan.com.np',
                icon: Icons.language_outlined,
                onTap: () => _launchUrl('https://www.anishchauhan.com.np/'),
                gradientColors: [
                  const Color(0xFFB06AB3),
                  const Color(0xFF4568DC),
                ],
                isDark: isDark,
              ),
              const SizedBox(height: 30),
              Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              _buildFaqItem(
                question: 'How do I add a new task?',
                answer:
                    'To add a new task, tap the "+" button at the bottom of the screen. Fill in the details like title, description, time, and color, then tap "Add Task".',
                isDark: isDark,
              ),
              _buildFaqItem(
                question: 'How do I edit or delete a task?',
                answer:
                    'To edit a task, tap on the edit icon (pencil) on any task card. To delete, swipe the task from right to left, or use the delete button in the edit screen.',
                isDark: isDark,
              ),
              _buildFaqItem(
                question: 'What is AM and PM in time selection?',
                answer:
                    'AM is for morning times (from 12:00 midnight to 11:59 before lunch). PM is for afternoon and night times (from 12:00 noon to 11:59 at night). Simple rule: AM = morning, PM = afternoon/night.',
                isDark: isDark,
              ),
              _buildFaqItem(
                question: 'Can I sort my tasks in a different order?',
                answer:
                    'Tasks are automatically sorted by priority and time. High priority tasks appear before normal and low priority tasks, and within each priority level they are sorted by time.',
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLink({
    required String title,
    required String subtitle,
    required IconData icon,
    required Function() onTap,
    required List<Color> gradientColors,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorUtils.withAlpha10(Colors.black),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: gradientColors[0].withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.black54,
                          fontSize: 14,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDark ? Colors.grey[600] : Colors.black54,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem({
    required String question,
    required String answer,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorUtils.withAlpha10(Colors.black),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
          colorScheme: ColorScheme.light(
            primary: const Color(0xFF5E61F4),
          ),
        ),
        child: ExpansionTile(
          title: Text(
            question,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          iconColor: const Color(0xFF5E61F4),
          collapsedIconColor: isDark ? Colors.grey[400] : Colors.grey[700],
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.black87,
                  fontSize: 14,
                  height: 1.5,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
