class SocialPost {
  final String id;
  final String platform;
  final String content;
  final String imageUrl;
  final DateTime scheduledFor;

  SocialPost({
    required this.id,
    required this.platform,
    required this.content,
    required this.imageUrl,
    required this.scheduledFor,
  });
}
