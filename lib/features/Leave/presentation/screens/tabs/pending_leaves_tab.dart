import 'package:dynamic_emr/features/Leave/presentation/bloc/leave_bloc.dart';
import 'package:dynamic_emr/features/Leave/presentation/widgets/leave_application_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PendingLeavesTab extends StatefulWidget {
  const PendingLeavesTab({super.key});

  @override
  State<PendingLeavesTab> createState() => _PendingLeavesTabState();
}

class _PendingLeavesTabState extends State<PendingLeavesTab> {
  @override
  void initState() {
    super.initState();
    context.read<LeaveBloc>().add(PendingLeaveListEvent());
  }

  Future<void> _refreshData() async {
    context.read<LeaveBloc>().add(PendingLeaveListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: BlocBuilder<LeaveBloc, LeaveState>(
            builder: (context, state) {
              if (state.pendingLeaveStatus == LeaveStatus.loading) {
                return Center(child: CircularProgressIndicator());
              } else if (state.pendingLeaveStatus ==
                  LeaveStatus.pendingLeaveLoadSuccess) {
                final pendingLeave = state.pendingLeave;

                pendingLeave.sort(
                  (a, b) => b.applicationDate.compareTo(
                    a.applicationDate,
                  ), // Recent first according to applicationDate
                );
                return ListView.builder(
                  itemCount: pendingLeave.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < pendingLeave.length - 1 ? 8.0 : 0,
                      ),
                      child: LeaveApplicationCardWidget(
                        leave: pendingLeave[index],
                      ),
                    );
                  },
                );
              } else if (state.pendingLeaveStatus ==
                  LeaveStatus.pendingLeaveLoadError) {
                return Center(child: Text(state.message));
              }
              return const Center(child: Text("No pending leaves found"));
            },
          ),
        ),
      ),
    );
  }
}
