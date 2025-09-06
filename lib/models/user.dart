class User {
  final String name;
  final String avatar;
  final bool isVerified;
  final int followers;

  User({
    required this.name,
    required this.avatar,
    required this.isVerified,
    required this.followers,
  });

  String get formattedFollowers {
    if (followers >= 1000) {
      return '${(followers / 1000).toStringAsFixed(1)}k followers';
    }
    return '$followers followers';
  }
}