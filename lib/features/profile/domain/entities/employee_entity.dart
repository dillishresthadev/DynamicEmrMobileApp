
import 'package:dynamic_emr/features/profile/domain/entities/employee_current_shift_entity.dart';
import 'package:dynamic_emr/features/profile/domain/entities/employee_document_entity.dart';
import 'package:dynamic_emr/features/profile/domain/entities/employee_education_entity.dart';
import 'package:dynamic_emr/features/profile/domain/entities/employee_emergency_contact_entity.dart';
import 'package:dynamic_emr/features/profile/domain/entities/employee_insurance_details_entity.dart';
import 'package:dynamic_emr/features/profile/domain/entities/employee_nominee_entity.dart';
import 'package:dynamic_emr/features/profile/domain/entities/employee_permanent_address_entity.dart';
import 'package:dynamic_emr/features/profile/domain/entities/employee_temporary_address_entity.dart';

class EmployeeEntity {
  final int id;
  final String employeeName;
  final String firstName;
  final String middleName;
  final String lastName;
  final String shortName;
  final String devnagariName;
  final String employeeCode;
  final String designationTitle;
  final String mobileNumber;
  final String workBranchTitle;
  final String workAddress;
  final String homeEmail;
  final String panNumber;
  final String maritalStatus;
  final String gender;
  final String birthDate;
  final String birthPlace;
  final String nationalityCountryId;
  final String religionId;
  final String ethnicityId;
  final String motherTongue;
  final String visaNo;
  final String workPermitNo;
  final String bloodGroup;
  final String imagePath;
  final String status;
  final String employeeDisplayName;
  final String employeeFullName;
  final DateTime joiningDate;
  final String salaryType;
  final String bankName;
  final String bankAccountNumber;
  final String bankAccountType;
  final List<EmployeeEducationEntity> employeeEducations;
  final List<EmployeeEmergencyContactEntity> employeeEmergencyContacts;
  final List<EmployeeNomineeEntity> employeeNominees;
  final EmployeePermanentAddressEntity permanentAddress;
  final EmployeeTemporaryAddressEntity temporaryAddress;
  final List<EmployeeInsuranceDetailsEntity> employeeInsuranceDetails;
  final List<EmployeeDocumentEntity> employeeDocuments;
  final EmployeeCurrentShiftEntity employeeCurrentShift;

  EmployeeEntity({
    required this.id,
    required this.employeeName,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.shortName,
    required this.devnagariName,
    required this.employeeCode,
    required this.designationTitle,
    required this.mobileNumber,
    required this.workBranchTitle,
    required this.workAddress,
    required this.homeEmail,
    required this.panNumber,
    required this.maritalStatus,
    required this.gender,
    required this.birthDate,
    required this.birthPlace,
    required this.nationalityCountryId,
    required this.religionId,
    required this.ethnicityId,
    required this.motherTongue,
    required this.visaNo,
    required this.workPermitNo,
    required this.bloodGroup,
    required this.imagePath,
    required this.status,
    required this.employeeDisplayName,
    required this.employeeFullName,
    required this.joiningDate,
    required this.salaryType,
    required this.bankName,
    required this.bankAccountNumber,
    required this.bankAccountType,
    required this.employeeEducations,
    required this.employeeEmergencyContacts,
    required this.employeeNominees,
    required this.permanentAddress,
    required this.temporaryAddress,
    required this.employeeInsuranceDetails,
    required this.employeeDocuments,
    required this.employeeCurrentShift,
    required List<dynamic> employeeWorkExperienceContacts,
  });
}
