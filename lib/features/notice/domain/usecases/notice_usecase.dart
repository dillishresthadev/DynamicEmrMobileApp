import 'package:dynamic_emr/features/notice/domain/entities/notice_entity.dart';
import 'package:dynamic_emr/features/notice/domain/repository/notice_repository.dart';

class NoticeUsecase {
  final NoticeRepository repository;

  NoticeUsecase({required this.repository});

  Future<List<NoticeEntity>> call() async {
    return await repository.getAllNotices();
  }
}
