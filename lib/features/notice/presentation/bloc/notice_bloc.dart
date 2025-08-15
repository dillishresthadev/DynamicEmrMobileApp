import 'dart:async';

import 'package:dynamic_emr/features/notice/domain/entities/notice_entity.dart';
import 'package:dynamic_emr/features/notice/domain/usecases/notice_by_id_usecase.dart';
import 'package:dynamic_emr/features/notice/domain/usecases/notice_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notice_event.dart';
part 'notice_state.dart';

class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {
  final NoticeByIdUsecase noticeByIdUsecase;
  final NoticeUsecase noticeUsecase;
  NoticeBloc({required this.noticeByIdUsecase, required this.noticeUsecase})
    : super(NoticeState()) {
    on<AllNoticesEvent>(_onAllNotice);
  }

  Future<void> _onAllNotice(
    AllNoticesEvent event,
    Emitter<NoticeState> emit,
  ) async {
    try {
      emit(state.copyWith(status: NoticeStatus.loading));
      final allNotice = await noticeUsecase.call();

      emit(state.copyWith(notices: allNotice, status: NoticeStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: NoticeStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
