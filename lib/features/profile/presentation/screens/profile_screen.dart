import 'dart:io';

import 'package:dynamic_emr/core/utils/url_launcher_utils.dart';
import 'package:dynamic_emr/core/widgets/html_viewer_screen.dart';
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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _loadAppVersion();

    // Trigger the profile fetch when screen loads
    context.read<ProfileBloc>().add(GetEmployeeDetailsEvent());
  }

  String _appVersion = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DynamicEMRAppBar(
        title: "Profile",
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, RouteNames.settingScreen),
            icon: Icon(Icons.settings),
          ),
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
                          Navigator.pushReplacementNamed(
                            context,
                            RouteNames.loginScreen,
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
        child: RefreshIndicator(
          onRefresh: () async {
            _loadAppVersion();

            context.read<ProfileBloc>().add(GetEmployeeDetailsEvent());
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                BlocBuilder<ProfileBloc, ProfileState>(
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
                _buildStaticSection(context),
              ],
            ),
          ),
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
            "Oops! Something went wrong [No Profile]",
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

  Widget _buildStaticSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            "Connect With Us",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 10),
          ProfileMenuCard(
            icon: FontAwesomeIcons.facebook,
            title: "Facebook Page",
            subTitle: "Follow our official page",
            iconColor: Colors.blue,
            bgColor: Colors.blue.shade50,
            press: () {
              UrlLauncherUtils.openFacebook();
            },
          ),
          // ProfileMenuCard(
          //   icon: FontAwesomeIcons.facebookF,
          //   title: "Facebook Group",
          //   subTitle: "Join our community",
          //   iconColor: Colors.blue,
          //   bgColor: Colors.blue.shade50,
          //   press: () {
          //     UrlLauncherUtils.openFacebook();
          //   },
          // ),
          // ProfileMenuCard(
          //   icon: FontAwesomeIcons.youtube,
          //   title: "YouTube",
          //   subTitle: "Subscribe to our channel",
          //   iconColor: Colors.red,
          //   bgColor: Colors.red.shade50,
          //   press: () {
          //     // open youtube link
          //   },
          // ),
          // ProfileMenuCard(
          //   icon: FontAwesomeIcons.tiktok,
          //   title: "TikTok",
          //   subTitle: "Watch our TikTok videos",
          //   iconColor: Colors.pink,
          //   bgColor: Colors.pink.shade50,
          //   press: () {
          //     // open TikTok link
          //   },
          // ),
          ProfileMenuCard(
            icon: FontAwesomeIcons.instagram,
            title: "Instagram",
            subTitle: "Follow us on Instagram",
            iconColor: Colors.purple,
            bgColor: Colors.purple.shade50,
            press: () {
              UrlLauncherUtils.openInstagram();
            },
          ),
          ProfileMenuCard(
            icon: Platform.isIOS
                ? FontAwesomeIcons.appStoreIos
                : FontAwesomeIcons.play,
            title: "Rate Us",
            subTitle: "Give us your feedback",
            iconColor: Colors.blue,
            bgColor: Colors.blue.shade50,
            press: () => UrlLauncherUtils.openAppRating(),
          ),
          ProfileMenuCard(
            icon: Icons.info_outline,
            title: "About Us",
            subTitle: "Know more about our app",
            iconColor: Colors.green,
            bgColor: Colors.green.shade50,
            press: () {
              UrlLauncherUtils.launchUrlExternal("https://dynamicemr.net");
            },
          ),

          // AppVersion
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                _appVersion,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = "version: ${info.version}";
    });
  }

  Widget _buildProfileView(employee) {
    return Column(
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
                iconColor: Colors.blue,

                bgColor: Colors.blue.shade50,
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
                iconColor: Colors.red,
                bgColor: Colors.red.shade50,
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
                iconColor: Colors.blueGrey,
                bgColor: Colors.blueGrey.shade50,
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
                iconColor: Colors.indigo,
                bgColor: Colors.indigo.shade50,
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
                iconColor: Colors.teal,
                bgColor: Colors.teal.shade50,
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
                iconColor: Colors.deepPurple,
                bgColor: Colors.deepPurple.shade50,
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
                icon: Icons.privacy_tip,
                title: "Privacy Policy",
                subTitle: "View our privacy policy",
                iconColor: Colors.orange,
                bgColor: Colors.orange.shade50,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HtmlViewerScreen(
                        filePath: 'assets/files/privacy_policy.html',
                        title: 'Privacy Policy',
                      ),
                    ),
                  );
                },
              ),
              ProfileMenuCard(
                icon: Icons.article_outlined,
                title: "Terms and Conditions",
                subTitle: "View our terms and condtions",
                iconColor: Colors.cyan,
                bgColor: Colors.cyan.shade50,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HtmlViewerScreen(
                        filePath: 'assets/files/terms_and_conditions.html',
                        title: 'Terms and Conditions',
                      ),
                    ),
                  );
                },
              ),
              ProfileMenuCard(
                icon: Icons.logout_rounded,
                title: "Logout",
                subTitle: "Logging out from Dynamic ERM",
                iconColor: Colors.redAccent,
                bgColor: Colors.red.shade50,
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
                                RouteNames.loginScreen,
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
    );
  }
}
