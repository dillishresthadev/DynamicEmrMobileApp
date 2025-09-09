import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';
import 'package:dynamic_emr/core/routes/route_names.dart';
import 'package:dynamic_emr/core/utils/app_snack_bar.dart';
import 'package:dynamic_emr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HospitalCodeScreen extends StatefulWidget {
  const HospitalCodeScreen({super.key});

  @override
  State<HospitalCodeScreen> createState() => _HospitalCodeScreenState();
}

class _HospitalCodeScreenState extends State<HospitalCodeScreen> {
  final TextEditingController _pinController = TextEditingController();
  String enteredCode = '';
  bool isLoading = false;

  void _validateAndSubmit() {
    if (enteredCode.length == 6 && !isLoading) {
      setState(() => isLoading = true);
      context.read<AuthBloc>().add(
        GetHospitalBaseUrlEvent(hospitalCode: enteredCode),
      );
    }
  }

  void _clearOtpField() {
    setState(() {
      enteredCode = '';
      _pinController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthLoadingState) {
          setState(() => isLoading = true);
        } else {
          setState(() => isLoading = false);
        }

        if (state is HospitalBaseUrlSuccessState) {
          // Save hospital code in secure storage
          final secureStorage = HospitalCodeStorage(
            const FlutterSecureStorage(),
          );
          await secureStorage.saveHospitalCode(enteredCode);

          // Mark onboarding as completed using SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('hospital_code_set', true);

          // Navigate to login screen
          Navigator.pushReplacementNamed(context, RouteNames.loginScreen);
        } else if (state is AuthErrorState) {
          AppSnackBar.show(context, state.errorMessage, SnackbarType.error);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: IgnorePointer(
                  ignoring: isLoading,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Enter Hospital Code",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "This is a unique 6-digit code for your hospital. Contact your IT department if you don't have the code.",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 30),
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: _pinController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        autoFocus: true,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(10),
                          fieldHeight: 56,
                          fieldWidth: 56,
                          activeFillColor: Colors.white,
                          inactiveFillColor: Colors.white,
                          selectedFillColor: Colors.white,
                        ),
                        enableActiveFill: true,
                        onChanged: (value) {
                          setState(() {
                            enteredCode = value;
                          });
                        },
                        onCompleted: (value) {
                          _validateAndSubmit();
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: _clearOtpField,
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed:
                                    (enteredCode.length == 6 && !isLoading)
                                    ? _validateAndSubmit
                                    : null,
                                child: const Text(
                                  "Continue Login",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading) const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
