import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:share_plus/share_plus.dart';
import '../screens/about_screen.dart';
import '../screens/help_support_screen.dart';
import '../utils/color_utils.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<UserModel>(
        builder: (context, userModel, child) {
          // Determine colors based on dark mode
          final Color iconColor =
              userModel.isDarkMode ? Colors.white70 : Colors.grey.shade700;

          final Color textColor =
              userModel.isDarkMode ? Colors.white : Colors.grey.shade800;

          return Column(
            children: [
              // User Header - Not scrollable
              _buildUserHeader(context, userModel),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // About
                      _buildMenuItem(
                        context,
                        icon: Icons.info_outline,
                        title: 'About',
                        iconColor: iconColor,
                        textColor: textColor,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutScreen(),
                            ),
                          );
                        },
                      ),

                      // Settings

                      // Help & Support
                      _buildMenuItem(
                        context,
                        icon: Icons.help_outline_rounded,
                        title: 'Help & Support',
                        iconColor: iconColor,
                        textColor: textColor,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpSupportScreen(),
                            ),
                          );
                        },
                      ),

                      // Website
                      _buildMenuItem(
                        context,
                        icon: Icons.language_outlined,
                        title: 'Website',
                        iconColor: iconColor,
                        textColor: textColor,
                        onTap: () {
                          Navigator.pop(context);
                          _launchURL('https://www.anishchauhan.com.np/');
                        },
                      ),

                      // Share App
                      _buildMenuItem(
                        context,
                        icon: Icons.share_outlined,
                        title: 'Share App',
                        iconColor: iconColor,
                        textColor: textColor,
                        onTap: () {
                          Navigator.pop(context);
                          _shareApp();
                        },
                      ),

                      // Dark Mode Toggle
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  userModel.isDarkMode
                                      ? Icons.dark_mode_rounded
                                      : Icons.light_mode_rounded,
                                  color: userModel.isDarkMode
                                      ? Colors.white70
                                      : const Color(0xFF4568DC),
                                  size: 22,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Dark Mode',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              value: userModel.isDarkMode,
                              onChanged: (value) {
                                userModel.toggleDarkMode();
                              },
                              activeColor: const Color(0xFF4568DC),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // App Version
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            color: Colors.white.withAlpha(38),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, UserModel userModel) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4568DC),
            Color(0xFF5E3BC3),
          ],
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: userModel.hasProfileImage
                        ? Image.file(
                            userModel.profileImage!,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.grey.shade300,
                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 12),

                // Name
                Text(
                  userModel.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // Email
                Text(
                  userModel.email,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Edit button positioned at the top right
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                _showCompleteProfileDialog(context, userModel);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit,
                  color: Color(0xFF4568DC),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color iconColor,
    required Color textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      horizontalTitleGap: 12,
    );
  }

  // Comprehensive profile edit dialog with image, name and email
  void _showCompleteProfileDialog(BuildContext context, UserModel userModel) {
    final nameController = TextEditingController(text: userModel.name);
    final emailController = TextEditingController(text: userModel.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile Picture Preview and Edit Option
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF4568DC).withOpacity(0.5),
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: userModel.hasProfileImage
                            ? Image.file(
                                userModel.profileImage!,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: Colors.grey.shade200,
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _showImageSourceDialog(context, userModel);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4568DC),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.photo_camera,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Name Field
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 16),

              // Email Field
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                await userModel.setName(nameController.text);
              }
              if (emailController.text.isNotEmpty) {
                await userModel.setEmail(emailController.text);
              }
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4568DC),
            ),
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Show dialog to pick image from camera or gallery
  void _showImageSourceDialog(BuildContext context, UserModel userModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Profile Picture'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera, userModel);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery, userModel);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // Pick image from camera or gallery
  Future<void> _pickImage(ImageSource source, UserModel userModel) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imageName =
            'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final localImage = File('${directory.path}/$imageName');

        // Copy the image to a local file
        final imageData = await File(image.path).readAsBytes();
        await localImage.writeAsBytes(imageData);

        // Update user model
        await userModel.setImagePath(localImage.path);

        // After picking an image, show the edit dialog again
        await Future.delayed(const Duration(milliseconds: 300));
        if (userModel.hasProfileImage) {
          _showCompleteProfileDialog(
              userModel.profileImage!.parent.parent as BuildContext, userModel);
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  // Direct URL launcher
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await url_launcher.launchUrl(url,
        mode: url_launcher.LaunchMode.externalApplication)) {
      debugPrint('Could not launch $urlString');
    }
  }

  // Share app
  Future<void> _shareApp() async {
    try {
      await Share.share(
          'Check out this amazing Task Scheduler app: https://play.google.com/store/apps/taskscheduler',
          subject: 'Task Scheduler App');
    } catch (e) {
      debugPrint('Could not share app: $e');
    }
  }
}
