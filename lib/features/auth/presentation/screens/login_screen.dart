import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/core/routes/route_names.dart';
import 'package:dynamic_emr/core/utils/app_snack_bar.dart';
import 'package:dynamic_emr/core/widgets/form/custom_input_field.dart';
import 'package:dynamic_emr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isObscure = true;
  bool _rememberMe = false;
  DateTime? lastBackPressedTime;
  bool hasSavedCredentials = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginSuccessState) {
          Navigator.pushReplacementNamed(
            context,
            RouteNames.selectBranchScreen,
          );
        } else if (state is AuthErrorState) {
          AppSnackBar.show(context, state.errorMessage, SnackbarType.error);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: constraints.maxHeight * 0.15),
                      SizedBox(
                        height: 140,
                        child: Image.asset("assets/logo/logo.jpeg"),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.05),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomInputField(
                              hintText: 'Username',
                              prefixIcon: const Icon(
                                Icons.account_circle_outlined,
                              ),
                              controller: _usernameController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Username is required';
                                }
                                return null;
                              },
                            ),
                            CustomInputField(
                              hintText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              obscureText: _isObscure,
                              maxLines: 1,
                              suffixIcon: IconButton(
                                onPressed: () =>
                                    setState(() => _isObscure = !_isObscure),
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                              ),
                              controller: _passwordController,
                            ),
                            SizedBox(height: constraints.maxHeight * 0.007),
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value!;
                                    });
                                  },
                                ),
                                Text("Remember Me"),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  context.read<AuthBloc>().add(
                                    LoginEvent(
                                      _usernameController.text.trim(),
                                      _passwordController.text.trim(),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(200, 48),
                                shape: const StadiumBorder(),
                              ),
                              child: Text("LOGIN"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
