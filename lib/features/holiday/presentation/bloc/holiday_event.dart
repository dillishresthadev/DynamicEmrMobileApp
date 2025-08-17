part of 'holiday_bloc.dart';

sealed class HolidayEvent extends Equatable {
  const HolidayEvent();

  @override
  List<Object> get props => [];
}

final class GetAllHolidayList extends HolidayEvent {}

final class PastHolidayList extends HolidayEvent {}

final class UpcommingHolidayList extends HolidayEvent {}
