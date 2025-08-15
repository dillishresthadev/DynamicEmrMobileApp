part of 'notice_bloc.dart';

sealed class NoticeEvent extends Equatable {
  const NoticeEvent();

  @override
  List<Object> get props => [];
}

class AllNoticesEvent extends NoticeEvent {}

class NoticeByIdEvent extends NoticeEvent {
  final int noticeId;

  const NoticeByIdEvent({required this.noticeId});
  @override
  List<Object> get props => [noticeId];
}
