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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DynamicEMRAppBar(
        title: "Employee Contracts",
        automaticallyImplyLeading: true,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is EmployeeContractLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EmployeeContractError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is EmployeeContractLoadedState) {
            final contracts = state.contracts;

            if (contracts.isEmpty) {
              return const Center(
                child: Text(
                  "No contracts available.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: contracts.length,
              itemBuilder: (context, index) {
                final contract = contracts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ContractCard(contract: contract),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class ContractCard extends StatelessWidget {
  final EmployeeContractEntity contract;

  const ContractCard({super.key, required this.contract});

  Color getStatusColor() {
    if (contract.status.toLowerCase() == 'inactive') return Colors.redAccent;
    if (contract.status.toLowerCase() == 'active') return Colors.green;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Employee Name & Code
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    contract.employeeName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  contract.employeeCode,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Contract Details
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    contract.contractType,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    contract.typeOfEmploymentTitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Dates & Level
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Start: ${contract.contractStartDateNp}",
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
                Text(
                  "End: ${contract.contractEndDateNp}",
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "Level: ${contract.levelTitle}, Grade: ${contract.gradeNo}",
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 8),

            // Status & Total Income
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor().withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    contract.status,
                    style: TextStyle(
                      color: getStatusColor(),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                Text(
                  "Income: ${contract.totalIncomeYearly.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
