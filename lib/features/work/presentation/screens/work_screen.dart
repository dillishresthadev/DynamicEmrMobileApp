import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_summary_entity.dart';
import 'package:dynamic_emr/features/work/presentation/bloc/work_bloc.dart';
import 'package:dynamic_emr/features/work/presentation/screens/create_ticket_form_screen.dart';
import 'package:dynamic_emr/features/work/presentation/screens/ticket_screen.dart';
import 'package:dynamic_emr/features/work/presentation/widgets/priority_chart_widget.dart';
import 'package:dynamic_emr/features/work/presentation/widgets/severity_chart_widget.dart';
import 'package:dynamic_emr/features/work/presentation/widgets/work_completion_rate_card_widget.dart';
import 'package:dynamic_emr/features/work/presentation/widgets/work_overview_card_widget.dart';
import 'package:dynamic_emr/features/work/presentation/widgets/work_status_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key});

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<WorkBloc>().add(MyTicketSummaryEvent());
    context.read<WorkBloc>().add(TicketAssignedToMeSummaryEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future _refreshData() async {
    context.read<WorkBloc>().add(MyTicketSummaryEvent());
    context.read<WorkBloc>().add(TicketAssignedToMeSummaryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: DynamicEMRAppBar(
        title: "Work Summary",
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
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateTicketFormScreen(),
                ),
              );
            },
            child: Row(
              children: [
                Icon(Icons.add_circle_outline),
                SizedBox(width: 5),
                Text("Create Ticket"),
                SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTicketSummary('My Tickets'),
          _buildAssignedTicketSummary('Assigned Tickets'),
        ],
      ),
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TicketScreen(initialTabIndex: _tabController.index),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: Size(double.infinity, 40),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            'View Ticket',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildTicketSummary(String title) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.0),
        child: BlocBuilder<WorkBloc, WorkState>(
          builder: (context, state) {
            if (state.myTicketStatus == WorkStatus.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.myTicketStatus == WorkStatus.success) {
              final myTickets = state.myTicketSummary;
              if (myTickets == null) {
                return Center(child: Text("You haven't created any tickets"));
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOverviewCards(myTickets),
                  SizedBox(height: 12),
                  WorkStatusChartWidget(ticketSummary: myTickets),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SeverityChartWidget(ticketSummary: myTickets),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: PriorityChartWidget(ticketSummary: myTickets),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  WorkCompletionRateCardWidget(ticketSummary: myTickets),
                ],
              );
            }
            return Center(child: Text("Error: ${state.myTicketStatus}"));
          },
        ),
      ),
    );
  }

  Widget _buildAssignedTicketSummary(String title) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.0),
        child: BlocBuilder<WorkBloc, WorkState>(
          builder: (context, state) {
            if (state.assignedTicketStatus == WorkStatus.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.assignedTicketStatus == WorkStatus.success) {
              final myTickets = state.ticketAssignedToMeSummary;
              if (myTickets == null) {
                return Center(
                  child: Text("You don't have any assigned tickets"),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOverviewCards(myTickets),
                  SizedBox(height: 12),
                  WorkStatusChartWidget(ticketSummary: myTickets),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SeverityChartWidget(ticketSummary: myTickets),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: PriorityChartWidget(ticketSummary: myTickets),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  WorkCompletionRateCardWidget(ticketSummary: myTickets),
                ],
              );
            }
            return Center(child: Text("Error: ${state.assignedTicketStatus}"));
          },
        ),
      ),
    );
  }

  Widget _buildOverviewCards(TicketSummaryEntity data) {
    return Row(
      children: [
        Expanded(
          child: WorkOverviewCardWidget(
            title: 'Tickets',
            value: (data.open + data.closed + data.inProgress).toString(),
            icon: Icons.assignment,
            color: Color(0xFF1E3A8A),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicketScreen(
                    initialTabIndex: _tabController.index,
                    ticketStatus: 'Open',
                  ),
                ),
              );
            },
            child: WorkOverviewCardWidget(
              title: 'Open',
              value: data.open.toString(),
              icon: Icons.hourglass_empty,
              color: Color(0xFFEF4444),
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicketScreen(
                    initialTabIndex: _tabController.index,
                    ticketStatus: 'Closed',
                  ),
                ),
              );
            },
            child: WorkOverviewCardWidget(
              title: 'Closed',
              value: data.closed.toString(),
              icon: Icons.done,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }
}
