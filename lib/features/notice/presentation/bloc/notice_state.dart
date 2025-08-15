part of 'notice_bloc.dart';


enum NoticeStatus { initial, loading, success, error }

class NoticeState extends Equatable {
  final NoticeStatus status;
  final List<NoticeEntity> notices;
  final String? errorMessage;

  const NoticeState({
    this.status = NoticeStatus.initial,
    this.notices = const [],
    this.errorMessage,
  });

  NoticeState copyWith({
    NoticeStatus? status,
    List<NoticeEntity>? notices,
    String? errorMessage,
  }) {
    return NoticeState(
      status: status ?? this.status,
      notices: notices ?? this.notices,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, notices, errorMessage];
}

