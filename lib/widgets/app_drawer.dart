import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class AppDrawer extends StatelessWidget {
  final String currentPage;
  final Function(String) onPageSelected;

  const AppDrawer({
    Key? key,
    required this.currentPage,
    required this.onPageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.surface,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildNavigationList(context)),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restaurant_menu,
                size: 50,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                    text: 'flavorful',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: '.',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Recipe Collection',
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationList(BuildContext context) {
    final navigationItems = [
      {'title': 'Home', 'icon': Icons.home, 'page': 'home'},
      {'title': 'Profile', 'icon': Icons.person, 'page': 'profile'},
      {'title': 'Bookmarks', 'icon': Icons.bookmark, 'page': 'bookmarks'},
      {'title': 'Settings', 'icon': Icons.settings, 'page': 'settings'},
    ];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Navigation',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        ...navigationItems.map((item) {
          final isSelected = currentPage == item['page'];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
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
                onPageSelected(item['page'] as String);
              },
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(20),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
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
    );
  }
}