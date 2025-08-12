import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/features/Leave/presentation/bloc/leave_bloc.dart';
import 'package:dynamic_emr/features/Leave/presentation/screens/apply_leave_form_screen.dart';
import 'package:dynamic_emr/features/Leave/presentation/screens/tabs/approved_leaves_tab.dart';
import 'package:dynamic_emr/features/Leave/presentation/screens/tabs/pending_leaves_tab.dart';
import 'package:dynamic_emr/features/Leave/presentation/widgets/leave_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLeaveData();
  }

  void _loadLeaveData() {
    final leaveBloc = context.read<LeaveBloc>();
    leaveBloc
      ..add(LeaveHistoryEvent())
      ..add(ApprovedLeaveListEvent())
      ..add(PendingLeaveListEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DynamicEMRAppBar(title: "Leaves"),
      body: Column(
        children: [
          _buildAvailableLeavesSection(),
          _buildTabBarSection(),
          _buildTabViewSection(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ApplyLeaveFormScreen()),
        ),
        label: Text('Apply Leave'),
        icon: Icon(Icons.add),

        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildAvailableLeavesSection() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          const Text(
            'Available Leaves',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<LeaveBloc, LeaveState>(
            builder: (context, state) {
              // Loading state for leave history
              if (state.status == LeaveStatus.loading &&
                  state.leaveHistory.isEmpty) {
                return const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              // Error state
              if (state.status == LeaveStatus.leaveHistoryLoadError &&
                  state.leaveHistory.isEmpty) {
                return _buildErrorContainer(state.message);
              }

              // Show grid
              if (state.leaveHistory.isEmpty) {
                return _buildEmptyContainer();
              }

              return _buildLeaveHistoryGrid(state.leaveHistory);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveHistoryGrid(List<dynamic> leaveHistory) {
    final itemCount = leaveHistory.length;
    final crossAxisCount = 2;
    final rowCount = (itemCount / crossAxisCount).ceil();
    const itemHeight = 80.0;
    const spacing = 8.0;
    final gridHeight = (rowCount * itemHeight) + ((rowCount - 1) * spacing);

    return SizedBox(
      height: gridHeight,
      child: GridView.builder(
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

          return LeaveCardWidget(
            icon: config['icon'] as IconData,
            color: config['color'] as Color,
            bgColor: config['bgColor'] as Color,
            count: leave.balance.toString(),
            label: leave.leaveType,
          );
        },
      ),
    );
  }

  Widget _buildErrorContainer(String message) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.2,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade600),
            const SizedBox(height: 8),
            Text(
              "Error: $message",
              style: TextStyle(color: Colors.red.shade700),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyContainer() {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Center(
        child: Text(
          'No leave data available',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildTabBarSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade600,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        tabs: const [
          Tab(text: 'Approved'),
          Tab(text: 'Pending'),
        ],
      ),
    );
  }

  Widget _buildTabViewSection() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: const [ApprovedLeavesTab(), PendingLeavesTab()],
      ),
    );
  }
}
