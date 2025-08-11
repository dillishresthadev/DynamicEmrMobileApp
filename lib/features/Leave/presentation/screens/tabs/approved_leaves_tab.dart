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
    context.read<LeaveBloc>().add(PendingLeaveListEvent());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LeaveBloc, LeaveState>(
        builder: (context, state) {
          if (state is LeaveLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ApprovedLeaveLoadedState) {
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
          return Center(child: Text("Unknown state $state"));
        },
      ),
    );
  }
}
