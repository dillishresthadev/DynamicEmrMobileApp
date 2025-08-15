import 'package:dynamic_emr/features/notice/data/datasource/notice_remote_datasource.dart';
import 'package:dynamic_emr/features/notice/domain/entities/notice_entity.dart';
import 'package:dynamic_emr/features/notice/domain/repository/notice_repository.dart';

class NoticeRepositoryImpl extends NoticeRepository {
  final NoticeRemoteDatasource remoteDatasource;

  NoticeRepositoryImpl({required this.remoteDatasource});
  @override
  Future<List<NoticeEntity>> getAllNotices() async {
    return await remoteDatasource.getAllNotices();
  }

  @override
  Future<NoticeEntity> getNoticeById(int noticeId) async {
    return await remoteDatasource.getNoticeById(noticeId);
  }
}
