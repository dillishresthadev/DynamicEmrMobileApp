import 'package:dynamic_emr/features/profile/data/models/employee_current_shift_model.dart';
import 'package:dynamic_emr/features/profile/data/models/employee_document_model.dart';
import 'package:dynamic_emr/features/profile/data/models/employee_education_model.dart';
import 'package:dynamic_emr/features/profile/data/models/employee_emergency_contact_model.dart';
import 'package:dynamic_emr/features/profile/data/models/employee_insurance_details_model.dart';
import 'package:dynamic_emr/features/profile/data/models/employee_nominee_model.dart';
import 'package:dynamic_emr/features/profile/data/models/employee_permanent_address_model.dart';
import 'package:dynamic_emr/features/profile/data/models/employee_temporary_address_model.dart';
import 'package:dynamic_emr/features/profile/data/models/employee_work_experience_model.dart';
import 'package:dynamic_emr/features/profile/domain/entities/employee_entity.dart';

class EmployeeModel extends EmployeeEntity {
  EmployeeModel({
    required super.id,
    required super.employeeName,
    required super.firstName,
    required super.middleName,
    required super.lastName,
    required super.shortName,
    required super.devnagariName,
    required super.employeeCode,
    required super.designationTitle,
    required super.mobileNumber,
    required super.workBranchTitle,
    required super.workAddress,
    required super.homeEmail,
    required super.panNumber,
    required super.maritalStatus,
    required super.gender,
    required super.birthDate,
    required super.birthPlace,
    required super.nationalityCountryId,
    required super.religionId,
    required super.ethnicityId,
    required super.motherTongue,
    required super.visaNo,
    required super.workPermitNo,
    required super.bloodGroup,
    required super.imagePath,
    required super.status,
    required super.employeeDisplayName,
    required super.employeeFullName,
    required super.joiningDate,
    required super.salaryType,
    required super.bankName,
    required super.bankAccountNumber,
    required super.bankAccountType,
    required super.employeeEducations,
    required super.employeeEmergencyContacts,
    required super.employeeNominees,
    required super.permanentAddress,
    required super.temporaryAddress,
    required super.employeeInsuranceDetails,
    required super.employeeDocuments,
    required super.employeeCurrentShift,
    required super.employeeWorkExperienceContacts,
    required super.employeeImageBaseUrl,
    required super.documentBaseUrl,
  });

  // Method to create an instance from JSON
  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] ?? '',
      employeeName: json['employeeName'] ?? '',
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'] ?? '',
      lastName: json['lastName'] ?? '',
      shortName: json['shortName'] ?? '',
      devnagariName: json['devnagariName'] ?? '',
      employeeCode: json['employeeCode'] ?? '',
      designationTitle: json['designationTitle'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      workBranchTitle: json['workBranchTitle'] ?? '',
      workAddress: json['workAddress'] ?? '',
      homeEmail: json['homeEmail'] ?? '',
      panNumber: json['panNumber'] ?? '',
      maritalStatus: json['maritalStatus'] ?? '',
      gender: json['gender'] ?? '',
      birthDate: json['birthDate'] ?? '',
      birthPlace: json['birthPlace'] ?? '',
      nationalityCountryId: json['countryOfBirth']?.toString() ?? '',
      religionId: json['religionId']?.toString() ?? '',
      ethnicityId: json['ethnicityId']?.toString() ?? '',
      motherTongue: json['motherTongue'] ?? '',
      visaNo: json['visaNo'] ?? '',
      workPermitNo: json['workPermitNo'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      imagePath: json['imagePath'] ?? '',
      status: json['status'] ?? '',
      employeeDisplayName: json['employeeDisplayName'] ?? '',
      employeeFullName: json['employeeFullName'] ?? '',
      joiningDate:
          DateTime.tryParse(json['joiningDate'] ?? '') ?? DateTime(2000),
      salaryType: json['salaryType'] ?? '',
      bankName: json['bankName'] ?? '',
      bankAccountNumber: json['bankAccountNumber'] ?? '',
      bankAccountType: json['bankAccountType'] ?? '',

      employeeWorkExperienceContacts:
          (json['employeeWorkExperienceContacts'] as List?)
              ?.map((e) => EmployeeWorkExperienceModel.fromJson(e))
              .toList() ??
          [],

      employeeEducations:
          (json['employeeEducations'] as List?)
              ?.map((e) => EmployeeEducationModel.fromJson(e))
              .toList() ??
          [],

      employeeEmergencyContacts:
          (json['employeeEmergencyContacts'] as List?)
              ?.map((e) => EmployeeEmergencyContactModel.fromJson(e))
              .toList() ??
          [],

      employeeNominees:
          (json['employeeNominees'] as List?)
              ?.map((e) => EmployeeNomineeModel.fromJson(e))
              .toList() ??
          [],

      permanentAddress: json['permanentAddress'] != null
          ? EmployeePermanentAddressModel.fromJson(json['permanentAddress'])
          : EmployeePermanentAddressModel(
              addressLine1: '',
              city: '',
              ward: '',
              municipalName: '',
            ),

      temporaryAddress: json['temporaryAddress'] != null
          ? EmployeeTemporaryAddressModel.fromJson(json['temporaryAddress'])
          : EmployeeTemporaryAddressModel(
              addressLine1: '',
              city: '',
              ward: '',
              municipalName: '',
            ),

      employeeInsuranceDetails:
          (json['employeeInsuranceDetails'] as List?)
              ?.map((e) => EmployeeInsuranceDetailsModel.fromJson(e))
              .toList() ??
          [],

      employeeDocuments:
          (json['employeeDocuments'] as List?)
              ?.map((e) => EmployeeDocumentModel.fromJson(e))
              .toList() ??
          [],

      employeeCurrentShift: json['employeeCurrentShift'] != null
          ? EmployeeCurrentShiftModel.fromJson(json['employeeCurrentShift'])
          : EmployeeCurrentShiftModel(),
      documentBaseUrl: json['documentBaseUrl'] ?? '',
      employeeImageBaseUrl: json['employeeImageBaseUrl'] ?? '',
    );
  }
}
