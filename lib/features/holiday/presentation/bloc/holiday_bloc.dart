import 'dart:async';
import 'dart:developer';

import 'package:dynamic_emr/features/holiday/domain/entities/holiday_entity.dart';
import 'package:dynamic_emr/features/holiday/domain/usecases/all_holiday_list_usecase.dart';
import 'package:dynamic_emr/features/holiday/domain/usecases/past_holiday_list_usecase.dart';
import 'package:dynamic_emr/features/holiday/domain/usecases/upcomming_holiday_list_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'holiday_event.dart';
part 'holiday_state.dart';

class HolidayBloc extends Bloc<HolidayEvent, HolidayState> {
  final AllHolidayListUsecase allHolidayListUsecase;
  final PastHolidayListUsecase pastHolidayListUsecase;
  final UpcommingHolidayListUsecase upcommingHolidayListUsecase;
  HolidayBloc({
    required this.allHolidayListUsecase,
    required this.pastHolidayListUsecase,
    required this.upcommingHolidayListUsecase,
  }) : super(HolidayState()) {
    on<GetAllHolidayList>(_onGetAllHolidayList);
    on<PastHolidayList>(_onPastHolidayList);
    on<UpcommingHolidayList>(_onUpcommingHolidayList);
  }

  Future<void> _onGetAllHolidayList(
    GetAllHolidayList event,
    Emitter<HolidayState> emit,
  ) async {
    try {
      final allHoliday = await allHolidayListUsecase.call();
      emit(
        state.copyWith(status: HolidayStatus.success, holidayList: allHoliday),
      );
    } catch (e) {
      log("Error Get All holiday list $e");
      emit(state.copyWith(message: e.toString(), status: HolidayStatus.error));
    }
  }

  Future<void> _onPastHolidayList(
    PastHolidayList event,
    Emitter<HolidayState> emit,
  ) async {
    try {
      final pastHoliday = await pastHolidayListUsecase.call();
      emit(
        state.copyWith(status: HolidayStatus.success, holidayList: pastHoliday),
      );
    } catch (e) {
      log("Error Get past holiday list $e");
      emit(state.copyWith(message: e.toString(), status: HolidayStatus.error));
    }
  }

  Future<void> _onUpcommingHolidayList(
    UpcommingHolidayList event,
    Emitter<HolidayState> emit,
  ) async {
    try {
      final upcommingHoliday = await upcommingHolidayListUsecase.call();
      emit(
        state.copyWith(
          status: HolidayStatus.success,
          holidayList: upcommingHoliday,
        ),
      );
    } catch (e) {
      log("Error Get upcomming holiday list $e");
      emit(state.copyWith(message: e.toString(), status: HolidayStatus.error));
    }
  }
}
