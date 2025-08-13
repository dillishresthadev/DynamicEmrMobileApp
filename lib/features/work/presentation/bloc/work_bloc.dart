import 'dart:async';
import 'dart:developer';

import 'package:dynamic_emr/features/work/domain/entities/ticket_categories_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_summary_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/work_user_entity.dart';
import 'package:dynamic_emr/features/work/domain/usecases/create_new_ticket_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/ticket_assigned_to_me_summary_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/ticket_categories_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/ticket_summary_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/work_user_list_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'work_event.dart';
part 'work_state.dart';

class WorkBloc extends Bloc<WorkEvent, WorkState> {
  final TicketSummaryUsecase ticketSummaryUsecase;
  final TicketAssignedToMeSummaryUsecase ticketAssignedToMeSummaryUsecase;
  final TicketCategoriesUsecase ticketCategoriesUsecase;
  final WorkUserListUsecase workUserListUsecase;
  final CreateNewTicketUsecase createNewTicketUsecase;
  WorkBloc({
    required this.ticketSummaryUsecase,
    required this.ticketAssignedToMeSummaryUsecase,
    required this.ticketCategoriesUsecase,
    required this.workUserListUsecase,
    required this.createNewTicketUsecase,
  }) : super(WorkState()) {
    on<MyTicketSummaryEvent>(_onMyTicketSummary);
    on<TicketAssignedToMeSummaryEvent>(_onTicketAssignedToMeSummary);
    on<TicketCategoriesEvent>(_onTicketCategories);
    on<WorkUserListEvent>(_onWorkUserList);
    on<CreateTicketEvent>(_onCreateTicket);
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

  Future<void> _onTicketCategories(
    TicketCategoriesEvent event,
    Emitter<WorkState> emit,
  ) async {
    emit(state.copyWith(workStatus: WorkStatus.loading));
    try {
      final ticketCategories = await ticketCategoriesUsecase.call();
      emit(
        state.copyWith(
          ticketCategories: ticketCategories,
          workStatus: WorkStatus.success,
        ),
      );
    } catch (e) {
      log("Error getting ticket categories $e");
      emit(
        state.copyWith(workStatus: WorkStatus.success, message: e.toString()),
      );
    }
  }

  FutureOr<void> _onWorkUserList(
    WorkUserListEvent event,
    Emitter<WorkState> emit,
  ) async {
    emit(state.copyWith(workStatus: WorkStatus.loading));
    try {
      final workUserList = await workUserListUsecase.call();
      emit(
        state.copyWith(workUser: workUserList, workStatus: WorkStatus.success),
      );
    } catch (e) {
      log("Error getting work user list $e");
      emit(
        state.copyWith(workStatus: WorkStatus.success, message: e.toString()),
      );
    }
  }

  Future<void> _onCreateTicket(
    CreateTicketEvent event,
    Emitter<WorkState> emit,
  ) async {
    emit(state.copyWith(workStatus: WorkStatus.loading));
    try {
      final ticket = await createNewTicketUsecase.call(
        event.ticketCategoryId,
        event.title,
        event.description,
        event.severity,
        event.priority,
        event.assignToEmployeeId,
        event.attachmentPaths,
      );
      emit(
        state.copyWith(createTicket: ticket, workStatus: WorkStatus.createTicketSuccess),
      );
    } catch (e) {
      log("Error getting work user list $e");
      emit(
        state.copyWith(workStatus: WorkStatus.createTicketError, message: e.toString()),
      );
    }
  }
}
