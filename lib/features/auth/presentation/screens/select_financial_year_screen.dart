import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/core/local_storage/branch_storage.dart';
import 'package:dynamic_emr/core/routes/route_names.dart';
import 'package:dynamic_emr/core/widgets/dropdown/custom_dropdown.dart';
import 'package:dynamic_emr/features/auth/domain/entities/user_financial_year_entity.dart';
import 'package:dynamic_emr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dynamic_emr/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectFinancialYearScreen extends StatefulWidget {
  const SelectFinancialYearScreen({super.key});

  @override
  State<SelectFinancialYearScreen> createState() =>
      _SelectFinancialYearScreenState();
}

class _SelectFinancialYearScreenState extends State<SelectFinancialYearScreen> {
  int? selectedFiscalYear;
  List<UserFinancialYearEntity> _fiscalYears = [];

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(GetHospitalFinancialYearEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton(color: Colors.blue)),
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthErrorState) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is AuthHospitalFinancialYearState) {
                _fiscalYears = state.financialYear;
              }

              final List<Map<String, dynamic>> fiscalYearNames = _fiscalYears
                  .map((fiscalYear) {
                    return {
                      'label': fiscalYear.financialYearCode,
                      'value': fiscalYear.financialYearId,
                    };
                  })
                  .toList();

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select Fiscal Year",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Please select the fiscal year to continue",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    CustomDropdown2(
                      value: selectedFiscalYear,
                      items: fiscalYearNames,
                      hintText: "Select Fiscal Year",
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedFiscalYear = value;
                          });
                          injection<BranchSecureStorage>()
                              .saveSelectedFiscalYearId(value.toString());
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: selectedFiscalYear != null
                          ? () {
                              Navigator.pushReplacementNamed(
                                context,
                                RouteNames.appMainNav,
                              );
                            }
                          : null,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: selectedFiscalYear != null
                              ? AppColors.primary
                              : AppColors.primary.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
