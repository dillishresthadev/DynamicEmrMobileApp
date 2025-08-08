import 'package:dynamic_emr/features/profile/presentation/widgets/profile_menu_card.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileMenuCard(
                icon: Icons.dark_mode,
                title: "App theme",
                subTitle: "Change your application theme",
                press: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
