class NoticeEntity {
  final int id;
  final String category;
  final String title;
  final String content;
  final bool isPublished;
  final DateTime? publishedTime;
  final String? tags;
  final dynamic featuredImage;
  final String excerpt;

  NoticeEntity({
    required this.id,
    required this.category,
    required this.title,
    required this.content,
    required this.isPublished,
    required this.publishedTime,
    required this.tags,
    required this.featuredImage,
    required this.excerpt,
  });
}
