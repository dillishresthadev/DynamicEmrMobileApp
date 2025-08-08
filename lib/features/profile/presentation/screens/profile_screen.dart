import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/core/routes/route_names.dart';
import 'package:dynamic_emr/core/widgets/curved_divider_painter.dart';
import 'package:dynamic_emr/features/profile/presentation/widgets/profile_menu_card.dart';
import 'package:dynamic_emr/features/profile/presentation/widgets/profile_picture_widget.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: Colors.white)),
        centerTitle: false,
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            onPressed: () => {
              Navigator.pushNamed(context, RouteNames.settingScreen),
            },
            icon: Icon(Icons.settings_outlined, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              color: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  ProfilePictureWidget(
                    profileUrl: "",
                    firstName: "CR",
                    lastName: "Poudyal",
                    avatarRadius: 70,
                  ),
                  SizedBox(height: 10),
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 10),
                      Text(
                        'CR Poudyal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
                    press: () {},
                  ),
                  ProfileMenuCard(
                    icon: Icons.person,
                    title: "Qualifications and Working Experience",
                    subTitle:
                        "Change your Qualifications and Working Experience",
                    press: () {},
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
                    press: () {},
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
                              "This action will log you out from Lawme.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {},
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
      ),
    );
  }
}
