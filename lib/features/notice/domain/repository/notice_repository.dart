import 'package:dynamic_emr/features/notice/domain/entities/notice_entity.dart';

abstract class NoticeRepository {
  Future<List<NoticeEntity>> getAllNotices();
  Future<NoticeEntity> getNoticeById(int noticeId);
}
