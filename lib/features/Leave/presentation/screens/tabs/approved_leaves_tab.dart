import 'package:dynamic_emr/features/Leave/presentation/bloc/leave_bloc.dart';
import 'package:dynamic_emr/features/Leave/presentation/widgets/leave_application_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApprovedLeavesTab extends StatefulWidget {
  const ApprovedLeavesTab({super.key});

  @override
  State<ApprovedLeavesTab> createState() => _ApprovedLeavesTabState();
}

class _ApprovedLeavesTabState extends State<ApprovedLeavesTab> {
  @override
  void initState() {
    super.initState();
    context.read<LeaveBloc>().add(ApprovedLeaveListEvent());
  }

  Future<void> _refreshData() async {
    context.read<LeaveBloc>().add(ApprovedLeaveListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: BlocBuilder<LeaveBloc, LeaveState>(
          builder: (context, state) {
            if (state.approvedLeaveStatus == LeaveStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.approvedLeaveStatus ==
                LeaveStatus.approvedLeaveLoadSuccess) {
              final approvedLeave = state.approvedLeave;
              return ListView.builder(
                itemCount: approvedLeave.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index < approvedLeave.length - 1 ? 8.0 : 0,
                    ),
                    child: LeaveApplicationCardWidget(
                      leave: approvedLeave[index],
                    ),
                  );
                },
              );
            }
            return const Center(child: Text("No approved leaves found"));
          },
        ),
      ),
    );
  }
}
