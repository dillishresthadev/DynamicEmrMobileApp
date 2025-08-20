part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, loaded, error }

final class ProfileState extends Equatable {
  final EmployeeEntity? employee;
  final List<EmployeeContractEntity> contracts;
  final ProfileStatus employeeStatus;
  final ProfileStatus contractStatus;
  final String employeeMessage;
  final String contractMessage;

  const ProfileState({
    this.employee,
    this.contracts = const [],
    this.employeeStatus = ProfileStatus.initial,
    this.contractStatus = ProfileStatus.initial,
    this.employeeMessage = '',
    this.contractMessage = '',
  });

  ProfileState copyWith({
    EmployeeEntity? employee,
    List<EmployeeContractEntity>? contracts,
    ProfileStatus? employeeStatus,
    ProfileStatus? contractStatus,

    String? employeeMessage,
    String? contractMessage,
  }) {
    return ProfileState(
      employee: employee ?? this.employee,
      contracts: contracts ?? this.contracts,
      employeeStatus: employeeStatus ?? this.employeeStatus,
      employeeMessage: employeeMessage ?? this.employeeMessage,
      contractStatus: contractStatus ?? this.contractStatus,
      contractMessage: contractMessage ?? this.contractMessage,
    );
  }

  @override
  List<Object?> get props => [
    employee,
    contracts,
    employeeStatus,
    employeeMessage,
    contractStatus,
    contractMessage,
  ];
}
