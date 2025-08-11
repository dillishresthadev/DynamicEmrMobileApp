import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/core/routes/route_names.dart';
import 'package:dynamic_emr/core/utils/app_snack_bar.dart';
import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/core/widgets/curved_divider_painter.dart';
import 'package:dynamic_emr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dynamic_emr/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:dynamic_emr/features/profile/presentation/screens/employee_details/personal_details_screen.dart';
import 'package:dynamic_emr/features/profile/presentation/screens/employee_details/qualification_experience_screen.dart';
import 'package:dynamic_emr/features/profile/presentation/screens/employee_details/work_and_shift_details_screen.dart';
import 'package:dynamic_emr/features/profile/presentation/widgets/profile_menu_card.dart';
import 'package:dynamic_emr/features/profile/presentation/widgets/profile_picture_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetEmployeeDetailsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Profile", style: TextStyle(color: Colors.white)),
      //   centerTitle: false,
      //   backgroundColor: AppColors.primary,
      //   automaticallyImplyLeading: false,
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         Navigator.pushNamed(context, RouteNames.settingScreen);
      //       },
      //       icon: Icon(Icons.settings_outlined, color: Colors.white),
      //     ),
      //   ],
      // ),
      appBar: DynamicEMRAppBar(
        title: "Profile",
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.settingScreen);
            },
            icon: Icon(Icons.settings_outlined, color: Colors.white),
          ),
        ],
      ),

      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileErrorState) {
            AppSnackBar.show(
              context,
              "Failed to load profile",
              SnackbarType.error,
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoadingState) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is ProfileLoadedState) {
              final employee = state.employee;

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
                            profileUrl: "",
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
                            subTitle: "Change your account information",
                            press: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PersonalDetailsScreen(employee: employee),
                              ),
                            ),
                          ),
                          ProfileMenuCard(
                            icon: Icons.person,
                            title: "Qualifications and Working Experience",
                            subTitle:
                                "Change your Qualifications and Working Experience",
                            press: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    QualificationExperienceScreen(
                                      employee: employee,
                                    ),
                              ),
                            ),
                          ),
                          ProfileMenuCard(
                            icon: Icons.model_training_rounded,
                            title: "Tranings and Certifications",
                            press: () {},
                          ),
                          ProfileMenuCard(
                            icon: Icons.work_outline,
                            title: "Working Experience",
                            press: () {},
                          ),
                          ProfileMenuCard(
                            icon: Icons.contact_emergency,
                            title: "Emergency Contact",
                            press: () {},
                          ),
                          ProfileMenuCard(
                            icon: Icons.business_center,
                            title: "Work and Shift Information",
                            press: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkAndShiftDetailsScreen(
                                  employee: employee,
                                ),
                              ),
                            ),
                          ),
                          ProfileMenuCard(
                            icon: Icons.file_copy_sharp,
                            title: "Documents",
                            press: () {},
                          ),
                          ProfileMenuCard(
                            icon: Icons.verified_user,
                            title: "Insurance Details",
                            press: () {},
                          ),
                          ProfileMenuCard(
                            icon: Icons.handshake,
                            title: "Employment Contracts",
                            press: () {},
                          ),
                          ProfileMenuCard(
                            icon: Icons.logout_rounded,
                            title: "Logout",
                            subTitle: "Logging out from Dynamic ERM",
                            press: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Are you sure?"),
                                    content: Text(
                                      "This action will log you out from Dynamic EMR.",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context.read<AuthBloc>().add(
                                            LogoutEvent(),
                                          );
                                          // After Logout Event is call navigate to Hospital Code Screen
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

            // Default state
            return Center(child: Text("No profile data"));
          },
        ),
      ),
    );
  }
}
