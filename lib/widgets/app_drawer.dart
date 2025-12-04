import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/app_theme.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../screens/auth/onboarding_screen.dart';

class AppDrawer extends StatefulWidget {
  final String currentPage;
  final Function(String) onPageSelected;

  const AppDrawer({
    Key? key,
    required this.currentPage,
    required this.onPageSelected,
  }) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await _authService.getUserData(user.uid);
      setState(() {
        _currentUser = userData;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.surface,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            _buildUserProfileHeader(context),
            Expanded(child: _buildNavigationList(context)),
            _buildLogoutSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileHeader(BuildContext context) {
    if (_currentUser == null) {
      return Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 20,
          bottom: 20,
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Text(
            'No user logged in',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 20,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    _currentUser!.displayName.isNotEmpty
                        ? _currentUser!.displayName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            _currentUser!.displayName,
                            style: const TextStyle(
                              fontFamily: AppTheme.fontFamily,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (_currentUser!.isVerifiedChef) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.verified, size: 18, color: Colors.white),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '@${_currentUser!.username}',
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNavigationList(BuildContext context) {
    final navigationItems = [
      {'title': 'Home', 'icon': Icons.home, 'page': 'home'},
      {'title': 'Profile', 'icon': Icons.person, 'page': 'profile'},
      {'title': 'Favorites', 'icon': Icons.favorite, 'page': 'favorites'},
      {'title': 'Settings', 'icon': Icons.settings, 'page': 'settings'},
    ];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Text(
            'Navigation',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        ...navigationItems.map((item) {
          final isSelected = widget.currentPage == item['page'];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  size: 20,
                ),
              ),
              title: Text(
                item['title'] as String,
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                widget.onPageSelected(item['page'] as String);
              },
            ),
          );
        }).toList(),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 1,
          color: AppColors.border,
        ),

        const Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text(
            'More',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.help_outline,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
            title: const Text(
              'Help & Support',
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _showSnackBar(context, 'Help & Support coming soon!');
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.info_outline,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
            title: const Text(
              'About',
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.red.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _showLogoutDialog(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Log Out',
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              children: [
                TextSpan(text: 'Made with '),
                TextSpan(text: '❤️', style: TextStyle(color: Colors.red)),
                TextSpan(text: ' for food lovers'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Log Out',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _performLogout(context);
              },
              child: const Text(
                'Log Out',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    try {
      await _authService.logout();

      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, 'Logout failed: $e');
      }
    }
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.restaurant_menu, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'flavorful.',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'A recipe sharing app with verified chefs, bringing authentic flavors from around the world to your kitchen.',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Close',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: AppTheme.fontFamily)),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}