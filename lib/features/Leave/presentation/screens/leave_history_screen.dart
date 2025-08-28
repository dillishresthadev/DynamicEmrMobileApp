import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/core/widgets/dropdown/custom_dropdown.dart';
import 'package:dynamic_emr/features/Leave/domain/entities/leave_history_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/entities/leave_type_entity.dart';
import 'package:dynamic_emr/features/Leave/presentation/bloc/leave_bloc.dart';
import 'package:dynamic_emr/features/Leave/presentation/screens/leave_application_history_screen.dart';
import 'package:dynamic_emr/features/Leave/presentation/widgets/available_leave_details_bottom_sheet_widget.dart';
import 'package:dynamic_emr/features/Leave/presentation/widgets/leave_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaveHistoryScreen extends StatefulWidget {
  const LeaveHistoryScreen({super.key});

  @override
  State<LeaveHistoryScreen> createState() => _LeaveHistoryScreenState();
}

class _LeaveHistoryScreenState extends State<LeaveHistoryScreen> {
  int? selectedContractPeriod;
  int? selectedFiscalYear;

  List<LeaveTypeEntity> contractList = [];
  List<LeaveTypeEntity> fiscalYearList = [];
  @override
  void initState() {
    super.initState();
    context.read<LeaveBloc>().add(GetContractEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: DynamicEMRAppBar(
        title: "Leave History",
        automaticallyImplyLeading: true,
      ),
      body: BlocConsumer<LeaveBloc, LeaveState>(
        listener: (context, state) {
          if (state.status == LeaveStatus.contractLoadSuccess) {
            contractList = state.leaveType;
          }
          if (state.status == LeaveStatus.fiscalYearLoadSuccess) {
            fiscalYearList = state.leaveType;
          }
        },
        builder: (context, state) {
          final contractListType = contractList
              .map((e) => {'label': e.text, 'value': int.tryParse(e.value)})
              .toList();
          final fiscalYearListType = fiscalYearList
              .map((e) => {'label': e.text, 'value': int.tryParse(e.value)})
              .toList();

          if (state.status == LeaveStatus.loading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
              ),
            );
          }

          if (state.status == LeaveStatus.leaveHistoryLoadError) {
            return Center(
              child: Text(
                "Error: ${state.message}",
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contract Period Dropdown
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Contract Period',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomDropdown2(
                      value: selectedContractPeriod,
                      items: contractListType,
                      hintText: 'Select a period',
                      onChanged: (value) {
                        setState(() {
                          selectedContractPeriod = value;
                          selectedFiscalYear = null;
                        });
                        if (selectedContractPeriod != null) {
                          // fetch fiscal year list by contract Id
                          context.read<LeaveBloc>().add(
                            GetFiscalYearByContractIdEvent(
                              contractId: selectedContractPeriod!,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // Fiscal Year Dropdown
                    const Text(
                      'Fiscal Year',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomDropdown2(
                      value: selectedFiscalYear,
                      items: fiscalYearListType,
                      hintText: 'Select a fiscal year',
                      onChanged: (value) {
                        setState(() {
                          selectedFiscalYear = value;
                        });
                        if (selectedContractPeriod != null &&
                            selectedFiscalYear != null) {
                          // fetch leave history by contract Id and fiscal year Id
                          context.read<LeaveBloc>().add(
                            LeaveApplicationHistoryEvent(
                              contractId: selectedContractPeriod!,
                              fiscalYearId: selectedFiscalYear!,
                            ),
                          );

                          // fetch available leaves (balances)
                          context.read<LeaveBloc>().add(
                            GetLeaveHistoryByContractIdFiscalYearIdEvent(
                              contractId: selectedContractPeriod!,
                              fiscalYearId: selectedFiscalYear!,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              Expanded(child: _buildAvailableLeavesSection()),
            ],
          );
        },
      ),
      persistentFooterButtons:
          (selectedContractPeriod != null && selectedFiscalYear != null)
          ? [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LeaveApplicationHistoryScreen(
                        contractId: selectedContractPeriod!,
                        fiscalYearId: selectedFiscalYear!,
                      ),
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
                  'View Leave History',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ]
          : [],
    );
  }

  Widget _buildAvailableLeavesSection() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: EdgeInsets.zero,
          title: const Text(
            'Available Leaves',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          children: [
            const SizedBox(height: 12),
            BlocBuilder<LeaveBloc, LeaveState>(
              builder: (context, state) {
                if (state.status == LeaveStatus.loading &&
                    state.leaveHistory.isEmpty) {
                  return const SizedBox(
                    height: 130,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return _buildLeaveHistoryGrid(state.leaveHistory);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveHistoryGrid(List<LeaveHistoryEntity> leaveHistory) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.3,
      ),
      itemCount: leaveHistory.length,
      itemBuilder: (context, index) {
        final leave = leaveHistory[index];
        final config = _getLeaveCardConfig(leave.leaveType);

        return InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (context) {
                return AvailableLeaveDetailsBottomSheetWidget(
                  leave: leave,
                  config: config,
                );
              },
            );
          },
          child: LeaveCardWidget(
            icon: config['icon'] as IconData,
            color: config['color'] as Color,
            bgColor: config['bgColor'] as Color,
            availableLeaaveCount: leave.balance.toString(),
            label: leave.leaveType,
          ),
        );
      },
    );
  }

  Map<String, dynamic> _getLeaveCardConfig(String leaveType) {
    return _statusCards.firstWhere(
      (card) => card['title'] == leaveType,
      orElse: () => {
        'title': leaveType,
        'icon': Icons.help_outline,
        'color': Colors.grey,
        'bgColor': Colors.grey.shade200,
      },
    );
  }

  static const List<Map<String, dynamic>> _statusCards = [
    {
      'title': 'Home Leave',
      'icon': Icons.home_outlined,
      'color': Color(0xFF2563EB),
      'bgColor': Color(0xFFEFF6FF),
    },
    {
      'title': 'Sick Leave',
      'icon': Icons.sick_outlined,
      'color': Color(0xFF10B981),
      'bgColor': Color(0xFFECFDF5),
    },
    {
      'title': 'Leave Without Pay',
      'icon': Icons.money_off,
      'color': Color(0xFFEF4444),
      'bgColor': Color(0xFFFEF2F2),
    },
    {
      'title': 'Satta Bida',
      'icon': Icons.change_circle_outlined,
      'color': Colors.orange,
      'bgColor': Color(0xFFFFF7E6),
    },
    {
      'title': 'Paternity Leave',
      'icon': Icons.child_care_outlined,
      'color': Colors.pink,
      'bgColor': Color(0xFFFFE6F8),
    },
  ];
}
