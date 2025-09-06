import 'user.dart';

class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> instructions;
  final String category;
  final String cookingTime;
  final String difficulty;
  final int servings;
  final double rating;
  final int likes;
  final User uploadedBy;
  final DateTime uploadDate;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.category,
    required this.cookingTime,
    required this.difficulty,
    required this.servings,
    required this.rating,
    required this.likes,
    required this.uploadedBy,
    required this.uploadDate,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(uploadDate);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }

  String get formattedLikes {
    if (likes >= 1000) {
      return '${(likes / 1000).toStringAsFixed(1)}k';
    }
    return likes.toString();
  }
}