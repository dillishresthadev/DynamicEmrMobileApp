import 'package:dynamic_emr/features/notice/domain/entities/notice_entity.dart';
import 'package:dynamic_emr/features/notice/domain/repository/notice_repository.dart';

class NoticeByIdUsecase {
  final NoticeRepository repository;

  NoticeByIdUsecase({required this.repository});

  Future<NoticeEntity> call(int noticeId) async {
    return await repository.getNoticeById(noticeId);
  }
}
