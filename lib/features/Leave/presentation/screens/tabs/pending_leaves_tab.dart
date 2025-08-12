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
    // Only call Pending API for this tab
    context.read<LeaveBloc>().add(PendingLeaveListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LeaveBloc, LeaveState>(
        buildWhen: (previous, current) {
          // Only rebuild UI if approved leaves list changes
          return previous.pendingLeave != current.pendingLeave ||
              (previous.status == LeaveStatus.loading) !=
                  (current.status == LeaveStatus.loading);
        },
        builder: (context, state) {
          if ((state.status == LeaveStatus.loading) &&
              (state.pendingLeave.isEmpty)) {
            return Center(child: CircularProgressIndicator());
          } else if (state.approvedLeave.isNotEmpty) {
            final pendingLeave = state.pendingLeave;
            return ListView.builder(
              itemCount: pendingLeave.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < pendingLeave.length - 1 ? 8.0 : 0,
                  ),
                  child: LeaveApplicationCardWidget(leave: pendingLeave[index]),
                );
              },
            );
          }
          return const Center(child: Text("No approved leaves found"));
        },
      ),
    );
  }
}
