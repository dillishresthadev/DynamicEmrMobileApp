import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_entity.dart';
import 'package:dynamic_emr/features/work/presentation/bloc/work_bloc.dart';
import 'package:dynamic_emr/features/work/presentation/widgets/ticket_filter_widget.dart';
import 'package:dynamic_emr/features/work/presentation/widgets/ticket_overview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    final DateTime now = DateTime.now();
    final DateTime oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
    _fromDateController.text = DateFormat('yyyy-MM-dd').format(oneMonthAgo);
    _toDateController.text = DateFormat('yyyy-MM-dd').format(now);

    context.read<WorkBloc>().add(
      FilterMyTicketEvent(
        ticketCategoryId: 0,
        status: "",
        priority: "",
        severity: "",
        assignTo: "",
        fromDate: "",
        toDate: "",
        orderBy: "",
      ),
    );
    context.read<WorkBloc>().add(
      FilterTicketAssignedToMeEvent(
        ticketCategoryId: 0,
        status: "",
        priority: "",
        severity: "",
        assignTo: "",
        fromDate: "",
        toDate: "",
        orderBy: "",
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

  Future<void> _refreshData() async {
    context.read<WorkBloc>().add(
      FilterMyTicketEvent(
        ticketCategoryId: 0,
        status: "",
        priority: "",
        severity: "",
        assignTo: "",
        fromDate: "",
        toDate: "",
        orderBy: "",
      ),
    );
    context.read<WorkBloc>().add(
      FilterTicketAssignedToMeEvent(
        ticketCategoryId: 0,
        status: "",
        priority: "",
        severity: "",
        assignTo: "",
        fromDate: "",
        toDate: "",
        orderBy: "",
      ),
    );
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
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return TicketFilterWidget();
                },
              );
            },
            icon: Icon(Icons.tune, color: Colors.white),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: TextStyle(fontWeight: FontWeight.w600),
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
            return TicketOverviewList(tickets: myTickets);
          }
          return Center(child: Text("Error: ${state.filterMyTicketStatus}"));
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
            return TicketOverviewList(tickets: assignedTickets);
          }
          return Center(
            child: Text("Error: ${state.filterAssignedTicketStatus}"),
          );
        },
      ),
    );
  }
}
