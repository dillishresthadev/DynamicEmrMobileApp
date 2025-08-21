import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/features/profile/domain/entities/employee_insurance_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dynamic_emr/features/profile/presentation/bloc/profile_bloc.dart';

class EmployeeInsuranceDetailsScreen extends StatefulWidget {
  const EmployeeInsuranceDetailsScreen({super.key});

  @override
  State<EmployeeInsuranceDetailsScreen> createState() =>
      _EmployeeInsuranceDetailsScreenState();
}

class _EmployeeInsuranceDetailsScreenState
    extends State<EmployeeInsuranceDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetEmployeeDetailsEvent());
  }

  List<EmployeeInsuranceDetailsEntity> _sortInsurances(
    List<EmployeeInsuranceDetailsEntity> insurances,
  ) {
    final sortedInsurances = List<EmployeeInsuranceDetailsEntity>.from(
      insurances,
    );

    // Sort by insured to date (active/valid first) and then by amount (highest first)
    sortedInsurances.sort((a, b) {
      // First priority: Active/valid insurances at top
      try {
        final dateA = (a.insuredToDate);
        final dateB = (b.insuredToDate);
        final now = DateTime.now();

        final isActiveA = dateA.isAfter(now);
        final isActiveB = dateB.isAfter(now);

        if (isActiveA && !isActiveB) return -1;
        if (isActiveB && !isActiveA) return 1;

        // Second priority: Sort by amount (highest first)
        return b.amount.compareTo(a.amount);
      } catch (e) {
        return 0;
      }
    });

    return sortedInsurances;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: DynamicEMRAppBar(
        title: "Employee Insurance",
        automaticallyImplyLeading: true,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.employeeStatus == ProfileStatus.loading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading insurance policies...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (state.employeeStatus == ProfileStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error Loading Insurance Policies',
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
                      state.employeeMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<ProfileBloc>().add(
                        GetEmployeeDetailsEvent(),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.employeeStatus == ProfileStatus.loaded) {
            final insurances = _sortInsurances(
              state.employee!.employeeInsuranceDetails,
            );

            if (insurances.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.security_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "No Insurance Policies",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "No insurance policies found for this employee.",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileBloc>().add(GetEmployeeDetailsEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: insurances.length,
                itemBuilder: (context, index) {
                  final insurance = insurances[index];
                  final isActivePolicy = _isActivePolicy(insurance);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: EnhancedInsuranceCard(
                      insurance: insurance,
                      isActivePolicy: isActivePolicy,
                      policyIndex: index + 1,
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

  bool _isActivePolicy(EmployeeInsuranceDetailsEntity insurance) {
    try {
      final endDate = (insurance.insuredToDate);
      return endDate.isAfter(DateTime.now());
    } catch (e) {
      return false;
    }
  }
}

class EnhancedInsuranceCard extends StatelessWidget {
  final EmployeeInsuranceDetailsEntity insurance;
  final bool isActivePolicy;
  final int policyIndex;

  const EnhancedInsuranceCard({
    super.key,
    required this.insurance,
    required this.isActivePolicy,
    required this.policyIndex,
  });

  Color getInsuranceTypeColor() {
    switch (insurance.type.toLowerCase()) {
      case 'life insurance':
        return Colors.blue;
      case 'health insurance':
        return Colors.green;
      case 'vehicle insurance':
        return Colors.orange;
      case 'property insurance':
        return Colors.purple;
      case 'travel insurance':
        return Colors.teal;
      default:
        return Colors.indigo;
    }
  }

  IconData getInsuranceTypeIcon() {
    switch (insurance.type.toLowerCase()) {
      case 'life insurance':
        return Icons.favorite;
      case 'health insurance':
        return Icons.local_hospital;
      case 'vehicle insurance':
        return Icons.directions_car;
      case 'property insurance':
        return Icons.home;
      case 'travel insurance':
        return Icons.flight;
      default:
        return Icons.security;
    }
  }

  String formatCurrencyNepali(double amount) {
    String amt = amount.toStringAsFixed(2);
    String decimalPart = "";
    if (amt.contains(".")) {
      decimalPart = amt.substring(amt.indexOf("."));
      amt = amt.substring(0, amt.indexOf("."));
    }

    String result = "";
    if (amt.length > 3) {
      String last3 = amt.substring(amt.length - 3);
      String remaining = amt.substring(0, amt.length - 3);

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

  int getDaysUntilExpiry() {
    try {
      final endDate = (insurance.insuredToDate);
      final now = DateTime.now();
      return endDate.difference(now).inDays;
    } catch (e) {
      return 0;
    }
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
    final daysUntilExpiry = getDaysUntilExpiry();
    final typeColor = getInsuranceTypeColor();

    return Card(
      elevation: isActivePolicy ? 8 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isActivePolicy
            ? BorderSide(color: typeColor.withValues(alpha: 0.3), width: 2)
            : BorderSide.none,
      ),
      shadowColor: isActivePolicy
          ? typeColor.withValues(alpha: 0.3)
          : Colors.black26,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isActivePolicy
              ? LinearGradient(
                  colors: [typeColor.withValues(alpha: 0.05), Colors.white],
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
              // Header with policy number and active badge
              Row(
                children: [
                  if (isActivePolicy)
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
                        'ACTIVE',
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
                    backgroundColor: typeColor.withValues(alpha: 0.1),
                    child: Text(
                      insurance.employeeName
                          .split(' ')
                          .map((e) => e.isNotEmpty ? e[0] : '')
                          .take(2)
                          .join()
                          .toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: typeColor,
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
                          insurance.employeeName,
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
                          insurance.employeeCode,
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

              // Insurance Type and Company
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                getInsuranceTypeIcon(),
                                size: 16,
                                color: typeColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Insurance Type',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            insurance.type,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: typeColor,
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
                          Row(
                            children: [
                              Icon(
                                Icons.business,
                                size: 16,
                                color: Colors.indigo,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Company',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            insurance.company,
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

              // Policy Duration
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
                          'Policy Duration',
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
                                'From Date',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                insurance.insuredFromDateNp,
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
                                'To Date',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                insurance.insuredToDateNp,
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

              // Policy Details
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      'Policy Number',
                      insurance.policyNumber,
                      icon: Icons.confirmation_number,
                    ),
                    _buildDetailRow(
                      'Country',
                      insurance.countryName,
                      icon: Icons.flag,
                    ),
                    _buildDetailRow(
                      'First Receipt No',
                      insurance.firstReceiptNo,
                      icon: Icons.receipt,
                    ),
                    _buildDetailRow(
                      'Receipt Date',
                      insurance.firstReceiptDateNp,
                      icon: Icons.date_range,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Amount Information
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
                          'Financial Details',
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
                                'Insurance Amount',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                'NPR ${formatCurrencyNepali(insurance.amount)}',
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
                                'Maturity Amount',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                'NPR ${formatCurrencyNepali(insurance.maturityPeriod)}',
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

              // Status and Tax Exemption Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isActivePolicy
                          ? Colors.green.withValues(alpha: 0.15)
                          : Colors.red.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isActivePolicy ? Icons.check_circle : Icons.cancel,
                          size: 16,
                          color: isActivePolicy ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isActivePolicy ? 'Active' : 'Expired',
                          style: TextStyle(
                            color: isActivePolicy ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (insurance.isIncomeTaxExemptionApplicable)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.savings,
                            size: 14,
                            color: Colors.purple[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Tax Exempt',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.purple[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Expiry Info
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: daysUntilExpiry < 0
                      ? Colors.red.withValues(alpha: 0.1)
                      : daysUntilExpiry <= 30
                      ? Colors.orange.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      daysUntilExpiry < 0
                          ? Icons.warning
                          : daysUntilExpiry <= 30
                          ? Icons.schedule
                          : Icons.info_outline,
                      size: 16,
                      color: daysUntilExpiry < 0
                          ? Colors.red[700]
                          : daysUntilExpiry <= 30
                          ? Colors.orange[700]
                          : Colors.grey[700],
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        daysUntilExpiry < 0
                            ? 'Expired ${daysUntilExpiry.abs()} days ago'
                            : daysUntilExpiry == 0
                            ? 'Expires today'
                            : 'Expires in $daysUntilExpiry days',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: daysUntilExpiry < 0
                              ? Colors.red[700]
                              : daysUntilExpiry <= 30
                              ? Colors.orange[700]
                              : Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
