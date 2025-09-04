import 'dart:developer';

import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_entity.dart';
import 'package:dynamic_emr/features/work/presentation/bloc/work_bloc.dart';
import 'package:dynamic_emr/features/work/presentation/screens/ticket_details_screen.dart';
import 'package:dynamic_emr/features/work/presentation/widgets/ticket_filter_widget.dart';
import 'package:dynamic_emr/features/work/presentation/widgets/ticket_overview_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TicketScreen extends StatefulWidget {
  final int initialTabIndex;
  final String ticketStatus;

  const TicketScreen({
    super.key,
    this.initialTabIndex = 0,
    this.ticketStatus = "",
  });

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen>
    with SingleTickerProviderStateMixin {
  TicketFilterData? _activeFilter;
  late TabController _tabController;
  TicketFilterData? _currentFilter;

  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, 1),
    );

    final DateTime now = DateTime.now();
    final DateTime oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
    _fromDateController.text = DateFormat('yyyy-MM-dd').format(oneMonthAgo);
    _toDateController.text = DateFormat('yyyy-MM-dd').format(now);

    _applyFilter(
      TicketFilterData(
        ticketCategoryId: 0,
        status: widget.ticketStatus,
        priority: "",
        severity: "",
        orderBy: "Newest",
        fromDate: "",
        toDate: "",
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();

    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  void _applyFilter(TicketFilterData filter) {
    _currentFilter = filter;

    context.read<WorkBloc>().add(
      FilterMyTicketEvent(
        ticketCategoryId: filter.ticketCategoryId,
        status: filter.status ?? "",
        priority: filter.priority ?? "",
        severity: filter.severity ?? "",
        assignTo: "",
        clientId: filter.clientId ?? 0,
        clientDesc: filter.clientDesc ?? "",
        clientDesc2: filter.clientDesc2 ?? "",
        fromDate: filter.fromDate,
        toDate: filter.toDate,
        orderBy: filter.orderBy ?? "",
      ),
    );

    context.read<WorkBloc>().add(
      FilterTicketAssignedToMeEvent(
        ticketCategoryId: filter.ticketCategoryId,
        status: filter.status ?? "",
        priority: filter.priority ?? "",
        severity: filter.severity ?? "",
        assignTo: "",
        clientId: filter.clientId ?? 0,
        clientDesc: filter.clientDesc ?? "",
        clientDesc2: filter.clientDesc2 ?? "",
        fromDate: filter.fromDate,
        toDate: filter.toDate,
        orderBy: filter.orderBy ?? "",
      ),
    );
  }

  Future<void> _refreshData() async {
    if (_currentFilter != null) {
      _applyFilter(_currentFilter!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DynamicEMRAppBar(
        title: "Ticket View",
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            onPressed: () {
              context.read<WorkBloc>().add(BusinessClientEvent());
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return DraggableScrollableSheet(
                    initialChildSize: 0.75,
                    minChildSize: 0.4,
                    maxChildSize: 0.9,
                    expand: false,

                    builder: (context, scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 16,
                              right: 16,
                              left: 16,
                              bottom:
                                  MediaQuery.of(context).viewInsets.bottom + 16,
                            ),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: TicketFilterWidget(
                                initialFilter: _activeFilter,
                                businessClient:
                                    context
                                        .read<WorkBloc>()
                                        .state
                                        .businessClient ??
                                    [],
                                onApply: (filter) {
                                  setState(() {
                                    _activeFilter = filter;
                                  });
                                  _applyFilter(filter);
                                },
                                onClear: () {
                                  _applyFilter(
                                    TicketFilterData(
                                      ticketCategoryId: 0,
                                      status: "",
                                      priority: "",
                                      severity: "",
                                      clientDesc: "",
                                      clientDesc2: "",
                                      orderBy: "",
                                      fromDate: "",
                                      toDate: "",
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            icon: Icon(Icons.tune, color: Colors.white),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 6,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          tabs: [
            Tab(text: 'My Tickets'),
            Tab(text: 'Assigned Tickets'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMyTicket('My Tickets'),
          _buildTicketAssignedToMe('Assigned Tickets'),
        ],
      ),
    );
  }

  Widget _buildMyTicket(String title) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: BlocBuilder<WorkBloc, WorkState>(
        builder: (context, state) {
          if (state.filterMyTicketStatus == WorkStatus.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.filterMyTicketStatus == WorkStatus.success) {
            final List<TicketEntity>? myTickets = state.filterMyTicket;
            if (myTickets == null || myTickets.isEmpty) {
              return Center(child: Text("You haven't created any tickets"));
            }
            return TicketOverviewListWidget(
              tickets: myTickets,
              onTap: (ticket) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TicketDetailsScreen(ticketId: ticket.id),
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildTicketAssignedToMe(String title) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: BlocBuilder<WorkBloc, WorkState>(
        builder: (context, state) {
          if (state.filterAssignedTicketStatus == WorkStatus.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.filterAssignedTicketStatus == WorkStatus.success) {
            final List<TicketEntity>? assignedTickets =
                state.filterMyAssignedTicket;
            if (assignedTickets == null || assignedTickets.isEmpty) {
              return Center(child: Text("You haven't any assigned tickets"));
            }
            return TicketOverviewListWidget(
              tickets: assignedTickets,
              onTap: (ticket) async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TicketDetailsScreen(ticketId: ticket.id),
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
