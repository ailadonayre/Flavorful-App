import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/user.dart';

class StatChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const StatChip({Key? key, required this.icon, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  final User user;
  final String? timeAgo;

  const UserInfo({Key? key, required this.user, this.timeAgo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(user.avatar, style: TextStyle(fontSize: 24)),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    user.name,
                    style: TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (user.isVerified) ...[
                    SizedBox(width: 4),
                    Icon(Icons.verified, size: 16, color: AppColors.accent),
                  ],
                ],
              ),
              Text(
                user.formattedFollowers,
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (timeAgo != null)
          Text(
            timeAgo!,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
  }
}