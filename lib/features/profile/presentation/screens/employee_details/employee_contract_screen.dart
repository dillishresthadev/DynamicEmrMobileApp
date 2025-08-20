import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dynamic_emr/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:dynamic_emr/features/profile/domain/entities/employee_contract_entity.dart';

class EmployeeContractListScreen extends StatefulWidget {
  const EmployeeContractListScreen({super.key});

  @override
  State<EmployeeContractListScreen> createState() =>
      _EmployeeContractListScreenState();
}

class _EmployeeContractListScreenState
    extends State<EmployeeContractListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetEmployeeContractEvent());
    context.read<ProfileBloc>().add(GetEmployeeDetailsEvent());
  }

  List<EmployeeContractEntity> _sortContracts(
    List<EmployeeContractEntity> contracts,
  ) {
    final sortedContracts = List<EmployeeContractEntity>.from(contracts);

    // Sort by start date (most recent first) and then by status (active first)
    sortedContracts.sort((a, b) {
      // First priority: Active contracts at top
      if (a.status.toLowerCase() == 'active' &&
          b.status.toLowerCase() != 'active') {
        return -1;
      }
      if (b.status.toLowerCase() == 'active' &&
          a.status.toLowerCase() != 'active') {
        return 1;
      }

      // Second priority: Sort by start date (most recent first)
      try {
        final dateA = DateTime.parse(a.contractStartDate as String);
        final dateB = DateTime.parse(b.contractStartDate as String);
        return dateB.compareTo(dateA);
      } catch (e) {
        return 0;
      }
    });

    return sortedContracts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: DynamicEMRAppBar(
        title: "Employee Contracts",
        automaticallyImplyLeading: true,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.contractStatus == ProfileStatus.loading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading contracts...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (state.contractStatus == ProfileStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error Loading Contracts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.contractMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<ProfileBloc>().add(
                        GetEmployeeContractEvent(),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.contractStatus == ProfileStatus.loaded) {
            final contracts = _sortContracts(state.contracts);

            if (contracts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "No Contracts Available",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "No employee contracts found in the system.",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileBloc>().add(GetEmployeeContractEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: contracts.length,
                itemBuilder: (context, index) {
                  final contract = contracts[index];
                  final isCurrentContract =
                      contract.status.toLowerCase() == 'active';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: EnhancedContractCard(
                      contract: contract,
                      isCurrentContract: isCurrentContract,
                      contractIndex: index + 1,
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class EnhancedContractCard extends StatelessWidget {
  final EmployeeContractEntity contract;
  final bool isCurrentContract;
  final int contractIndex;

  const EnhancedContractCard({
    super.key,
    required this.contract,
    required this.isCurrentContract,
    required this.contractIndex,
  });

  Color getStatusColor() {
    switch (contract.status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.redAccent;
      case 'expired':
        return Colors.orange;
      case 'terminated':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon() {
    switch (contract.status.toLowerCase()) {
      case 'active':
        return Icons.check_circle;
      case 'inactive':
        return Icons.pause_circle;
      case 'expired':
        return Icons.schedule;
      case 'terminated':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  String formatCurrencyNepali(double amount) {
    String amt = amount.toStringAsFixed(2); // keep 2 decimal places
    String decimalPart = "";
    if (amt.contains(".")) {
      decimalPart = amt.substring(amt.indexOf("."));
      amt = amt.substring(0, amt.indexOf("."));
    }

    // First group: take last 3 digits
    String result = "";
    if (amt.length > 3) {
      String last3 = amt.substring(amt.length - 3);
      String remaining = amt.substring(0, amt.length - 3);

      // Group remaining digits in 2s
      List<String> groups = [];
      while (remaining.length > 2) {
        groups.insert(0, remaining.substring(remaining.length - 2));
        remaining = remaining.substring(0, remaining.length - 2);
      }
      if (remaining.isNotEmpty) {
        groups.insert(0, remaining);
      }

      result = "${groups.join(",")},$last3";
    } else {
      result = amt;
    }

    return result + decimalPart;
  }

  Widget _buildDetailRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 8),
          ],
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isCurrentContract ? 8 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isCurrentContract
            ? BorderSide(color: Colors.green.withValues(alpha: 0.3), width: 2)
            : BorderSide.none,
      ),
      shadowColor: isCurrentContract
          ? Colors.green.withValues(alpha: 0.3)
          : Colors.black26,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isCurrentContract
              ? LinearGradient(
                  colors: [Colors.green.withValues(alpha: 0.05), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with contract number and current badge
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Contract #$contractIndex',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (isCurrentContract)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'CURRENT',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Employee Information
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blue.withValues(alpha: 0.1),
                    child: Text(
                      contract.employeeName
                          .split(' ')
                          .map((e) => e.isNotEmpty ? e[0] : '')
                          .take(2)
                          .join()
                          .toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contract.employeeName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          contract.employeeCode,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Contract Type and Employment Type
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contract Type',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            contract.contractType,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Employment',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            contract.typeOfEmploymentTitle,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.indigo,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Contract Duration
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Contract Duration',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start Date',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                contract.contractStartDateNp,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'End Date',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                contract.contractEndDateNp,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Position Details
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      'Level',
                      contract.levelTitle,
                      icon: Icons.stars,
                    ),
                    _buildDetailRow(
                      'Grade',
                      contract.gradeNo,
                      icon: Icons.grade,
                    ),
                    _buildDetailRow(
                      'Pay Package',
                      contract.payPackageTitle,
                      icon: Icons.payments,
                    ),
                    if (contract.otRate > 0)
                      _buildDetailRow(
                        'OT Rate',
                        formatCurrencyNepali(contract.otRate),
                        icon: Icons.access_time,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Income Information
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.withValues(alpha: 0.1),
                      Colors.green.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          size: 16,
                          color: Colors.green[700],
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Income Details',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Monthly Income',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                'NPR ${formatCurrencyNepali(contract.totalIncome)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Yearly Income',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                'NPR ${formatCurrencyNepali(contract.totalIncomeYearly)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Status and Expiry Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: getStatusColor().withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          getStatusIcon(),
                          size: 16,
                          color: getStatusColor(),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          contract.status,
                          style: TextStyle(
                            color: getStatusColor(),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: contract.expireInDays < 0
                          ? Colors.red.withValues(alpha: 0.1)
                          : contract.expireInDays <= 30
                          ? Colors.orange.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      contract.expireInDays < 0
                          ? 'Expired ${contract.expireInDays.abs()} days ago'
                          : contract.expireInDays == 0
                          ? 'Expires today'
                          : 'Expires in ${contract.expireInDays} days',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: contract.expireInDays < 0
                            ? Colors.red[700]
                            : contract.expireInDays <= 30
                            ? Colors.orange[700]
                            : Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
