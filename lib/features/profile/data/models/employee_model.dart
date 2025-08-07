import 'package:dynamic_emr/features/profile/data/models/employee_current_shift_model.dart';
import 'package:dynamic_emr/features/profile/data/models/employee_document_model.dart';
import 'package:dynamic_emr/features/profile/data/models/employee_education_model.dart';
import 'package:dynamic_emr/features/profile/data/models/employee_emergency_contact_model.dart';
import 'package:dynamic_emr/features/profile/data/models/employee_insurance_details_model.dart';
import 'package:dynamic_emr/features/profile/data/models/employee_nominee_model.dart';
import 'package:dynamic_emr/features/profile/data/models/employee_permanent_address_model.dart';
import 'package:dynamic_emr/features/profile/data/models/employee_temporary_address_model.dart';
import 'package:dynamic_emr/features/profile/data/models/employee_work_experience_model.dart';

class EmployeeModel {
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
  final List<EmployeeEducationModel> employeeEducations;
  final List<EmployeeEmergencyContactModel> employeeEmergencyContacts;
  final List<EmployeeNomineeModel> employeeNominees;
  final EmployeePermanentAddressModel permanentAddress;
  final EmployeeTemporaryAddressModel temporaryAddress;
  final List<EmployeeInsuranceDetailsModel> employeeInsuranceDetails;
  final List<EmployeeDocumentModel> employeeDocuments;
  final EmployeeCurrentShiftModel employeeCurrentShift;

  EmployeeModel({
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

  // Method to create an instance from JSON
  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      employeeName: json['employeeName'] ?? '',
      firstName: json['firstName'],
      middleName: json['middleName'] ?? '',
      lastName: json['lastName'],
      shortName: json['shortName'] ?? '',
      devnagariName: json['devnagariName'],
      employeeCode: json['employeeCode'],
      designationTitle: json['designationTitle'],
      mobileNumber: json['mobileNumber'] ?? '',
      workBranchTitle: json['workBranchTitle'],
      workAddress: json['workAddress'] ?? '',
      homeEmail: json['homeEmail'],
      panNumber: json['panNumber'] ?? '',
      maritalStatus: json['maritalStatus'],
      gender: json['gender'],
      birthDate: json['birthDate'],
      birthPlace: json['birthPlace'],
      nationalityCountryId: json['countryOfBirth'].toString(),
      religionId: json['religionId'].toString(),
      ethnicityId: json['ethnicityId'].toString(),
      motherTongue: json['motherTongue'],
      visaNo: json['visaNo'] ?? '',
      workPermitNo: json['workPermitNo'] ?? '',
      bloodGroup: json['bloodGroup'],
      imagePath: json['imagePath'] ?? '',
      status: json['status'],
      employeeDisplayName: json['employeeDisplayName'],
      employeeFullName: json['employeeFullName'],
      joiningDate: DateTime.parse(json['joiningDate']),
      salaryType: json['salaryType'],
      bankName: json['bankName'],
      bankAccountNumber: json['bankAccountNumber'],
      bankAccountType: json['bankAccountType'],
      employeeWorkExperienceContacts:
          (json['employeeWorkExperienceContacts'] as List)
              .map((e) => EmployeeWorkExperienceModel.fromJson(e))
              .toList(),
      employeeEducations: (json['employeeEducations'] as List)
          .map((e) => EmployeeEducationModel.fromJson(e))
          .toList(),
      employeeEmergencyContacts: (json['employeeEmergencyContacts'] as List)
          .map((e) => EmployeeEmergencyContactModel.fromJson(e))
          .toList(),
      employeeNominees: (json['employeeNominees'] as List)
          .map((e) => EmployeeNomineeModel.fromJson(e))
          .toList(),
      permanentAddress: EmployeePermanentAddressModel.fromJson(
        json['permanentAddress'],
      ),
      temporaryAddress: EmployeeTemporaryAddressModel.fromJson(
        json['temporaryAddress'],
      ),
      employeeInsuranceDetails: (json['employeeInsuranceDetails'] as List)
          .map((e) => EmployeeInsuranceDetailsModel.fromJson(e))
          .toList(),
      employeeDocuments: (json['employeeDocuments'] as List)
          .map((e) => EmployeeDocumentModel.fromJson(e))
          .toList(),
      employeeCurrentShift: EmployeeCurrentShiftModel.fromJson(
        json['employeeCurrentShift'],
      ),
    );
  }
}
