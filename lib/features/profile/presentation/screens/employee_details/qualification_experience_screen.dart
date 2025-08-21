import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/features/profile/domain/entities/employee_education_entity.dart';
import 'package:dynamic_emr/features/profile/domain/entities/employee_entity.dart';
import 'package:flutter/material.dart';

class QualificationExperienceScreen extends StatefulWidget {
  final EmployeeEntity employee;
  const QualificationExperienceScreen({super.key, required this.employee});

  @override
  State<QualificationExperienceScreen> createState() =>
      _QualificationExperienceScreenState();
}

class _QualificationExperienceScreenState
    extends State<QualificationExperienceScreen> {
  @override
  Widget build(BuildContext context) {
    final data = widget.employee;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const DynamicEMRAppBar(
        title: "Qualifications ",
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: data.employeeEducations.length,
                itemBuilder: (context, index) {
                  EmployeeEducationEntity qualificationdetails =
                      data.employeeEducations[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ExpansionTile(
                        title: Text(
                          qualificationdetails.qualification,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        childrenPadding: const EdgeInsets.all(16.0),
                        children: [
                          _buildInfoRow("School", qualificationdetails.school),
                          _buildInfoRow(
                            "Qualification",
                            qualificationdetails.qualification,
                          ),
                          _buildInfoRow("Level", qualificationdetails.level),
                          _buildInfoRow(
                            "Passed Year",
                            qualificationdetails.yearOfPassing,
                          ),
                          _buildInfoRow(
                            "Percentage",
                            qualificationdetails.percentageOrGrade,
                          ),
                          _buildInfoRow(
                            "Major Optional Subject",
                            qualificationdetails.majorOptionalSubject,
                          ),
                          _buildInfoRow(
                            "Division",
                            qualificationdetails.division,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Removed incorrect usage of WorkingExperience
    );
  }
  // Function to format date

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.withValues(alpha:0.7),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 30),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.withValues(alpha:0.7),
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
