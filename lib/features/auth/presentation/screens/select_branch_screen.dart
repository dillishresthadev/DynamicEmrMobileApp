import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/core/widgets/dropdown/custom_dropdown.dart';
import 'package:dynamic_emr/features/auth/domain/entities/hospital_branch_entity.dart';
import 'package:dynamic_emr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectBranchScreen extends StatefulWidget {
  const SelectBranchScreen({super.key});

  @override
  State<SelectBranchScreen> createState() => _SelectBranchScreenState();
}

class _SelectBranchScreenState extends State<SelectBranchScreen> {
  int? selectedBranch;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(GetHospitalBranchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(color: Colors.blue)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is AuthErrorState) {
                return Center(child: Text(state.errorMessage));
              }

              if (state is AuthHospitalBranchLoadedState) {
                List<HospitalBranchEntity> branches = state.hospitalBranch;

                List<Map<String, dynamic>> branchItems = branches
                    .map(
                      (branch) => {
                        'label': branch.branchName,
                        'value': branch.branchId,
                      },
                    )
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Select Branch ID",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Please select the branch ID to continue",
                      style: TextStyle(fontSize: 16, color: AppColors.navyBlue),
                    ),
                    const SizedBox(height: 20),
                    CustomDropdown2(
                      value: selectedBranch,
                      items: branchItems,
                      hintText: "Select Branch ID",
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedBranch = value;
                          });

                          // You can store it securely if needed
                          // SecureStorageService().writeData(
                          //   "selected_workingbranchId",
                          //   value.toString(),
                          // );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: selectedBranch != null
                          ? () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         SelectFiscalYearScreen(),
                              //   ),
                              // );
                            }
                          : null,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: selectedBranch != null
                              ? AppColors.primary
                              : AppColors.primary.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const Center(child: Text("No branch data available"));
            },
          ),
        ),
      ),
    );
  }
}
