part of 'holiday_bloc.dart';

enum HolidayStatus { initial, loading, success, error }

final class HolidayState extends Equatable {
  final List<HolidayEntity> holidayList;
  final HolidayStatus status;
  final String message;
  const HolidayState({
    this.holidayList = const [],
    this.message = '',
    this.status = HolidayStatus.initial,
  });

  HolidayState copyWith({
    List<HolidayEntity>? holidayList,
    HolidayStatus? status,
    String? message,
  }) {
    return HolidayState(
      holidayList: holidayList ?? this.holidayList,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [holidayList, status, message];
}
