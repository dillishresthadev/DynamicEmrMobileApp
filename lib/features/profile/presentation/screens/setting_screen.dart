import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';
import 'package:dynamic_emr/core/routes/route_names.dart';
import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/features/profile/presentation/widgets/profile_menu_card.dart';
import 'package:dynamic_emr/injection.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DynamicEMRAppBar(
        title: "Settings",
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileMenuCard(
                icon: Icons.delete_forever,
                title: "Remove Hospital Code",
                subTitle: "Navigate and remove code",
                iconColor: Colors.red,
                bgColor: Colors.red.shade50,
                press: () async {
                  // remove hospital code and base url
                  await injection<ISecureStorage>().removeHospitalCode();
                  await injection<ISecureStorage>().removeHospitalBaseUrl();
                  Navigator.pushReplacementNamed(
                    context,
                    RouteNames.hospitalCodeScreen,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
