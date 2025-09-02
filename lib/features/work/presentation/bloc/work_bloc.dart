import 'dart:async';
import 'dart:developer';

import 'package:dynamic_emr/features/work/domain/entities/business_client_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_categories_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_details_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_summary_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/work_user_entity.dart';
import 'package:dynamic_emr/features/work/domain/usecases/business_client_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/comment_on_ticket_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/create_new_ticket_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/edit_assignto_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/edit_priority_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/edit_severity_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/filter_my_ticket_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/filter_ticket_assigned_to_me_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/ticket_assigned_to_me_summary_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/ticket_categories_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/ticket_close_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/ticket_details_by_id_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/ticket_reopen_usecase.dart';
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
  final FilterMyTicketUsecase filterMyTicketUsecase;
  final FilterTicketAssignedToMeUsecase filterTicketAssignedToMeUsecase;
  final TicketDetailsByIdUsecase ticketDetailsByIdUsecase;
  final TicketCloseUsecase ticketCloseUsecase;
  final TicketReopenUsecase ticketReopenUsecase;
  final CommentOnTicketUsecase commentOnTicketUsecase;
  final EditPriorityUsecase editPriorityUsecase;
  final EditAssigntoUsecase editAssigntoUsecase;
  final EditSeverityUsecase editSeverityUsecase;
  final BusinessClientUsecase businessClientUsecase;
  WorkBloc({
    required this.ticketSummaryUsecase,
    required this.ticketAssignedToMeSummaryUsecase,
    required this.ticketCategoriesUsecase,
    required this.workUserListUsecase,
    required this.createNewTicketUsecase,
    required this.filterMyTicketUsecase,
    required this.filterTicketAssignedToMeUsecase,
    required this.ticketDetailsByIdUsecase,
    required this.ticketCloseUsecase,
    required this.ticketReopenUsecase,
    required this.commentOnTicketUsecase,
    required this.editPriorityUsecase,
    required this.editAssigntoUsecase,
    required this.editSeverityUsecase,
    required this.businessClientUsecase,
  }) : super(WorkState()) {
    on<MyTicketSummaryEvent>(_onMyTicketSummary);
    on<TicketAssignedToMeSummaryEvent>(_onTicketAssignedToMeSummary);
    on<TicketCategoriesEvent>(_onTicketCategories);
    on<WorkUserListEvent>(_onWorkUserList);
    on<CreateTicketEvent>(_onCreateTicket);
    on<FilterMyTicketEvent>(_onFilterMyTicket);
    on<FilterTicketAssignedToMeEvent>(_onFilterTicketAssignedToMe);
    on<TicketDetailsByIdEvent>(_onTicketDetailsById);
    on<TicketReopenEvent>(_onTicketReOpen);
    on<TicketClosedEvent>(_onTicketClosed);
    on<CommentOnTicketEvent>(_onCommentOnTicket);
    on<EditPriorityEvent>(_onEditPriority);
    on<EditAssignToEvent>(_onEditAssignedTo);
    on<EditSeverityEvent>(_onEditSeverity);
    on<BusinessClientEvent>(_onBusinessClientEvent);
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
        event.client,
        event.clientDesc,
        event.clientDesc2,
        event.dueDate,
        event.assignToEmployeeId,
        event.attachmentPaths,
      );
      if (ticket) {
        emit(
          state.copyWith(
            createTicket: ticket,
            workStatus: WorkStatus.createTicketSuccess,
          ),
        );
      } else {
        emit(
          state.copyWith(
            createTicket: ticket,
            workStatus: WorkStatus.createTicketError,
          ),
        );
      }
    } catch (e) {
      log("Error getting while ticket creating $e");
      emit(
        state.copyWith(
          workStatus: WorkStatus.createTicketError,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onFilterMyTicket(
    FilterMyTicketEvent event,
    Emitter<WorkState> emit,
  ) async {
    emit(state.copyWith(workStatus: WorkStatus.loading));
    try {
      final ticket = await filterMyTicketUsecase.call(
        event.ticketCategoryId,
        event.status,
        event.priority,
        event.severity,
        event.assignTo,
        event.fromDate,
        event.toDate,
        event.orderBy,
      );
      emit(
        state.copyWith(
          filterMyTicket: ticket,
          filterMyTicketStatus: WorkStatus.success,
        ),
      );
    } catch (e) {
      log("Error Bloc getting filter ticket $e");
      emit(
        state.copyWith(
          filterMyTicketStatus: WorkStatus.error,
          filterMyTicketMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onFilterTicketAssignedToMe(
    FilterTicketAssignedToMeEvent event,
    Emitter<WorkState> emit,
  ) async {
    emit(state.copyWith(workStatus: WorkStatus.loading));
    try {
      final ticket = await filterTicketAssignedToMeUsecase.call(
        event.ticketCategoryId,
        event.status,
        event.priority,
        event.severity,
        event.assignTo,
        event.fromDate,
        event.toDate,
        event.orderBy,
      );
      emit(
        state.copyWith(
          filterMyAssignedTicket: ticket,
          filterAssignedTicketStatus: WorkStatus.success,
        ),
      );
    } catch (e) {
      log("Error Bloc getting assigned ticket filter $e");
      emit(
        state.copyWith(
          filterAssignedTicketStatus: WorkStatus.error,
          filterMyAssignedTicketMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onTicketDetailsById(
    TicketDetailsByIdEvent event,
    Emitter<WorkState> emit,
  ) async {
    emit(state.copyWith(workStatus: WorkStatus.loading));
    try {
      final ticket = await ticketDetailsByIdUsecase.call(event.ticketId);
      final workUserList = await workUserListUsecase.call();

      emit(
        state.copyWith(
          ticketDetails: ticket,
          workUser: workUserList,
          workStatus: WorkStatus.ticketDetailsLoadSuccess,
        ),
      );
    } catch (e) {
      log("Error Bloc ticket details by Id $e");
      emit(
        state.copyWith(
          workStatus: WorkStatus.ticketDetailsError,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onTicketReOpen(
    TicketReopenEvent event,
    Emitter<WorkState> emit,
  ) async {
    emit(state.copyWith(workStatus: WorkStatus.loading));
    try {
      final isTicketReOpen = await ticketReopenUsecase.call(event.ticketId);
      final ticket = await ticketDetailsByIdUsecase.call(event.ticketId);

      emit(
        state.copyWith(
          reOpenTicket: isTicketReOpen,
          ticketDetails: ticket,
          workStatus: WorkStatus.success,
        ),
      );
    } catch (e) {
      log("Error Bloc ticket reopen $e");
      emit(state.copyWith(workStatus: WorkStatus.error, message: e.toString()));
    }
  }

  Future<void> _onTicketClosed(
    TicketClosedEvent event,
    Emitter<WorkState> emit,
  ) async {
    emit(state.copyWith(workStatus: WorkStatus.loading));
    try {
      final isTicketClosed = await ticketCloseUsecase.call(event.ticketId);
      final ticket = await ticketDetailsByIdUsecase.call(event.ticketId);

      emit(
        state.copyWith(
          closeTicket: isTicketClosed,
          ticketDetails: ticket,
          workStatus: WorkStatus.success,
        ),
      );
    } catch (e) {
      log("Error Bloc ticket closed $e");
      emit(state.copyWith(workStatus: WorkStatus.error, message: e.toString()));
    }
  }

  Future<void> _onCommentOnTicket(
    CommentOnTicketEvent event,
    Emitter<WorkState> emit,
  ) async {
    emit(state.copyWith(workStatus: WorkStatus.loading));
    try {
      final isComment = await commentOnTicketUsecase.call(
        event.ticketId,
        event.message,
        event.attachmentPaths,
      );
      final ticket = await ticketDetailsByIdUsecase.call(event.ticketId);

      emit(
        state.copyWith(
          commentOnTicket: isComment,
          ticketDetails: ticket,
          workStatus: WorkStatus.success,
        ),
      );
    } catch (e) {
      log("Error Bloc comment on ticket $e");
      emit(state.copyWith(workStatus: WorkStatus.error, message: e.toString()));
    }
  }

  Future<void> _onEditPriority(
    EditPriorityEvent event,
    Emitter<WorkState> emit,
  ) async {
    emit(state.copyWith(workStatus: WorkStatus.loading));
    try {
      await editPriorityUsecase.call(event.ticketId, event.status);
      final ticket = await ticketDetailsByIdUsecase.call(event.ticketId);

      emit(
        state.copyWith(workStatus: WorkStatus.success, ticketDetails: ticket),
      );
    } catch (e) {
      log("Error Bloc _onEditPriority $e");
      emit(state.copyWith(workStatus: WorkStatus.error, message: e.toString()));
    }
  }

  Future<void> _onEditAssignedTo(
    EditAssignToEvent event,
    Emitter<WorkState> emit,
  ) async {
    emit(state.copyWith(workStatus: WorkStatus.loading));
    try {
      await editAssigntoUsecase.call(event.ticketId, event.assignedUserId);
      final ticket = await ticketDetailsByIdUsecase.call(event.ticketId);

      emit(
        state.copyWith(workStatus: WorkStatus.success, ticketDetails: ticket),
      );
    } catch (e) {
      log("Error Bloc _onEditAssignedTo $e");
      emit(state.copyWith(workStatus: WorkStatus.error, message: e.toString()));
    }
  }

  Future<void> _onEditSeverity(
    EditSeverityEvent event,
    Emitter<WorkState> emit,
  ) async {
    emit(state.copyWith(workStatus: WorkStatus.loading));
    try {
      await editSeverityUsecase.call(event.ticketId, event.status);
      final ticket = await ticketDetailsByIdUsecase.call(event.ticketId);

      emit(
        state.copyWith(workStatus: WorkStatus.success, ticketDetails: ticket),
      );
    } catch (e) {
      log("Error Bloc _onEditSeverity $e");
      emit(state.copyWith(workStatus: WorkStatus.error, message: e.toString()));
    }
  }

  Future<void> _onBusinessClientEvent(
    BusinessClientEvent event,
    Emitter<WorkState> emit,
  ) async {
    emit(state.copyWith(workStatus: WorkStatus.loading));
    try {
      final clientList = await businessClientUsecase.call();
      emit(
        state.copyWith(
          businessClient: clientList,
          workStatus: WorkStatus.success,
        ),
      );
    } catch (e) {
      log("Error getting business client list $e");
      emit(
        state.copyWith(workStatus: WorkStatus.success, message: e.toString()),
      );
    }
  }
}
