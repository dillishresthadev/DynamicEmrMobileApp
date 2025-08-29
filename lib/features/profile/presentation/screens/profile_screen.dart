import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/core/routes/route_names.dart';
import 'package:dynamic_emr/core/utils/app_snack_bar.dart';
import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/core/widgets/curved_divider_painter.dart';
import 'package:dynamic_emr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dynamic_emr/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:dynamic_emr/features/profile/presentation/screens/employee_details/employee_contract_screen.dart';
import 'package:dynamic_emr/features/profile/presentation/screens/employee_details/employee_document_screen.dart';
import 'package:dynamic_emr/features/profile/presentation/screens/employee_details/employee_emergency_contact_screen.dart';
import 'package:dynamic_emr/features/profile/presentation/screens/employee_details/employee_insurance_details_screen.dart';
import 'package:dynamic_emr/features/profile/presentation/screens/employee_details/personal_details_screen.dart';
import 'package:dynamic_emr/features/profile/presentation/screens/employee_details/work_and_shift_details_screen.dart';
import 'package:dynamic_emr/features/profile/presentation/widgets/profile_menu_card.dart';
import 'package:dynamic_emr/features/profile/presentation/widgets/profile_picture_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger the profile fetch when screen loads
    context.read<ProfileBloc>().add(GetEmployeeDetailsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DynamicEMRAppBar(
        title: "Profile",
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog.adaptive(
                    title: Text("Are you sure?"),
                    content: Text(
                      "This action will log you out from Dynamic EMR.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(LogoutEvent());
                          // After Logout Event is called navigate to Hospital Code Screen
                          Navigator.pushReplacementNamed(
                            context,
                            RouteNames.hospitalCodeScreen,
                          );
                        },
                        child: Text(
                          "Logout",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.logout_outlined, color: Colors.white),
          ),
        ],
      ),

      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.employeeStatus == ProfileStatus.error) {
            AppSnackBar.show(
              context,
              "Failed to load profile",
              SnackbarType.error,
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.employeeStatus == ProfileStatus.loading) {
              return _buildLoadingState();
            }

            if (state.employeeStatus == ProfileStatus.error) {
              return _buildErrorState();
            }

            if (state.employeeStatus == ProfileStatus.loaded) {
              final employee = state.employee;
              if (employee != null) {
                return _buildProfileView(employee);
              } else {
                return _buildNoProfileDataState();
              }
            }

            // Fallback for any other state
            return _buildNoProfileDataState();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Oops! Something went wrong.[No Data]",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Retry the profile fetch
              context.read<ProfileBloc>().add(GetEmployeeDetailsEvent());
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text("Re-try", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildNoProfileDataState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No profile data available.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Retry the profile fetch
              context.read<ProfileBloc>().add(GetEmployeeDetailsEvent());
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text("Try Again", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView(employee) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.primary,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                ProfilePictureWidget(
                  profileUrl:
                      "${employee.employeeImageBaseUrl}/${employee.imagePath}",
                  firstName: employee.firstName,
                  lastName: employee.lastName,
                  avatarRadius: 70,
                ),
                SizedBox(height: 10),
                Text(
                  '${employee.firstName} ${employee.lastName}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  employee.employeeCode,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          CustomPaint(
            painter: CurvedDividerPainter(color: AppColors.primary),
            child: SizedBox(height: 25, width: double.infinity),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                ProfileMenuCard(
                  icon: Icons.person,
                  title: "Profile Information",
                  subTitle: "View your account information",
                  press: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PersonalDetailsScreen(employee: employee),
                    ),
                  ),
                ),
                ProfileMenuCard(
                  icon: Icons.contact_emergency,
                  title: "Emergency Contact",
                  subTitle: "View your emergency contact details",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployeeEmergencyContactScreen(
                          contacts: employee.employeeEmergencyContacts,
                        ),
                      ),
                    );
                  },
                ),
                ProfileMenuCard(
                  icon: Icons.business_center,
                  title: "Work and Shift Information",
                  subTitle: "View your work and shift information",
                  press: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WorkAndShiftDetailsScreen(employee: employee),
                    ),
                  ),
                ),
                ProfileMenuCard(
                  icon: Icons.file_copy_sharp,
                  title: "Documents",
                  subTitle: "View your attached documents",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployeeDocumentScreen(),
                      ),
                    );
                  },
                ),
                ProfileMenuCard(
                  icon: Icons.verified_user,
                  title: "Insurance Details",
                  subTitle: "View your insurance details",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployeeInsuranceDetailsScreen(),
                      ),
                    );
                  },
                ),
                ProfileMenuCard(
                  icon: Icons.handshake,
                  title: "Employment Contracts",
                  subTitle: "View your contracts details",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployeeContractListScreen(),
                      ),
                    );
                  },
                ),
                ProfileMenuCard(
                  icon: Icons.logout_rounded,
                  title: "Logout",
                  subTitle: "Logging out from Dynamic ERM",
                  press: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog.adaptive(
                          title: Text("Are you sure?"),
                          content: Text(
                            "This action will log you out from Dynamic EMR.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<AuthBloc>().add(LogoutEvent());
                                Navigator.pushReplacementNamed(
                                  context,
                                  RouteNames.hospitalCodeScreen,
                                );
                              },
                              child: Text(
                                "Logout",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
