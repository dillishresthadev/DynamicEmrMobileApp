import 'dart:async';
import 'dart:developer';

import 'package:dynamic_emr/features/work/domain/entities/ticket_summary_entity.dart';
import 'package:dynamic_emr/features/work/domain/usecases/ticket_assigned_to_me_summary_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/ticket_summary_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'work_event.dart';
part 'work_state.dart';

class WorkBloc extends Bloc<WorkEvent, WorkState> {
  final TicketSummaryUsecase ticketSummaryUsecase;
  final TicketAssignedToMeSummaryUsecase ticketAssignedToMeSummaryUsecase;
  WorkBloc({
    required this.ticketSummaryUsecase,
    required this.ticketAssignedToMeSummaryUsecase,
  }) : super(WorkState()) {
    on<MyTicketSummaryEvent>(_onMyTicketSummary);
    on<TicketAssignedToMeSummaryEvent>(_onTicketAssignedToMeSummary);
  }

  Future<void> _onMyTicketSummary(
    MyTicketSummaryEvent event,
    Emitter<WorkState> emit,
  ) async {
    emit(state.copyWith(myTicketStatus: WorkStatus.loading));
    try {
      final myticketSummary = await ticketSummaryUsecase.call();
      emit(
        state.copyWith(
          myTicketSummary: myticketSummary,
          myTicketStatus: WorkStatus.success,
        ),
      );
    } catch (e) {
      log("Error getting my ticket summary $e");
      emit(
        state.copyWith(
          myTicketStatus: WorkStatus.error,
          myTicketMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onTicketAssignedToMeSummary(
    TicketAssignedToMeSummaryEvent event,
    Emitter<WorkState> emit,
  ) async {
    emit(state.copyWith(assignedTicketStatus: WorkStatus.loading));
    try {
      final ticketAssignedToMeSummary = await ticketAssignedToMeSummaryUsecase
          .call();
      emit(
        state.copyWith(
          ticketAssignedToMeSummary: ticketAssignedToMeSummary,
          assignedTicketStatus: WorkStatus.success,
        ),
      );
    } catch (e) {
      log("Error getting ticket summary assigned to me$e");
      emit(
        state.copyWith(
          assignedTicketStatus: WorkStatus.success,
          assignedTicketMessage: e.toString(),
        ),
      );
    }
  }
}
