import 'package:dynamic_emr/features/notice/domain/entities/notice_entity.dart';

class NoticeModel extends NoticeEntity {
  NoticeModel({
    required super.id,
    required super.category,
    required super.title,
    required super.content,
    required super.isPublished,
    required super.publishedTime,
    required super.tags,
    required super.featuredImage,
    required super.excerpt,
  });
  factory NoticeModel.fromJson(Map<String, dynamic> json) => NoticeModel(
    id: json["id"],
    category: json["category"],
    title: json["title"],
    content: json["content"],
    isPublished: json["isPublished"],
    publishedTime: json["publishedTime"] == null
        ? null
        : DateTime.parse(json["publishedTime"]),
    tags: json["tags"] ?? '',
    featuredImage: json["featuredImage"],
    excerpt: json["excerpt"] ?? '',
  );
}
