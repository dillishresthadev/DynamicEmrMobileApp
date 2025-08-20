part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitialState extends ProfileState {}

final class ProfileLoadingState extends ProfileState {}

final class ProfileLoadedState extends ProfileState {
  final EmployeeEntity employee;

  const ProfileLoadedState({required this.employee});
  @override
  List<Object> get props => [employee];
}

final class EmployeeContractLoadedState extends ProfileState {
  final List<EmployeeContractEntity> contracts;

  const EmployeeContractLoadedState({required this.contracts});
  @override
  List<Object> get props => [contracts];
}

final class EmployeeContractLoadingState extends ProfileState {}

final class EmployeeContractError extends ProfileState {
  final String message;

  const EmployeeContractError({required this.message});
  @override
  List<Object> get props => [message];
}

final class ProfileErrorState extends ProfileState {
  final String errorMessage;

  const ProfileErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
