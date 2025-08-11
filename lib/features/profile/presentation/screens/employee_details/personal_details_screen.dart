import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/features/profile/domain/entities/employee_entity.dart';
import 'package:dynamic_emr/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalDetailsScreen extends StatefulWidget {
  final EmployeeEntity employee;
  const PersonalDetailsScreen({super.key, required this.employee});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  @override
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetEmployeeDetailsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.employee;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DynamicEMRAppBar(
        title: "Personal Information",
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoRow(
                title: "Full Name (English)",
                value: data.employeeFullName,
              ),
              InfoRow(title: "Full Name (Nepali)", value: data.devnagariName),
              InfoRow(title: "Email Address (Personal)", value: data.homeEmail),
              InfoRow(
                title: "Phone Number (Personal)",
                value: data.mobileNumber,
              ),
              InfoRow(title: "Gender", value: data.gender),
              InfoRow(title: "Date of Birth", value: data.birthDate),
              InfoRow(
                title: "Permanent Address",
                value:
                    '${data.permanentAddress.addressLine1}, ${data.permanentAddress.ward}, ${data.permanentAddress.municipalName}',
              ),
              InfoRow(
                title: "Temporary Address",
                value:
                    '${data.temporaryAddress.addressLine1}, ${data.temporaryAddress.ward}, ${data.temporaryAddress.municipalName}',
              ),
              InfoRow(title: "Marital Status", value: data.maritalStatus),
              InfoRow(title: "Blood Group", value: data.bloodGroup),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
