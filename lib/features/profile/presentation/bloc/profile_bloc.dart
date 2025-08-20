import 'dart:async';
import 'dart:developer';

import 'package:dynamic_emr/features/profile/domain/entities/employee_contract_entity.dart';
import 'package:dynamic_emr/features/profile/domain/entities/employee_entity.dart';
import 'package:dynamic_emr/features/profile/domain/usecases/employee_contract_usecase.dart';
import 'package:dynamic_emr/features/profile/domain/usecases/employee_details_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final EmployeeDetailsUsecase employeeDetailsUsecase;
  final EmployeeContractUsecase employeeContractUsecase;

  ProfileBloc({
    required this.employeeDetailsUsecase,
    required this.employeeContractUsecase,
  }) : super(const ProfileState()) {
    on<GetEmployeeDetailsEvent>(_onGetEmployeeDetailsEvent);
    on<GetEmployeeContractEvent>(_onGetEmployeeContracts);
  }

  Future<void> _onGetEmployeeDetailsEvent(
    GetEmployeeDetailsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(employeeStatus: ProfileStatus.loading));
      final employeeDetails = await employeeDetailsUsecase.call();
      emit(
        state.copyWith(
          employee: employeeDetails,

          employeeStatus: ProfileStatus.loaded,
        ),
      );
    } catch (e) {
      log("Error while getting employee details (profile) : $e");
      emit(
        state.copyWith(
          employeeStatus: ProfileStatus.error,
          employeeMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onGetEmployeeContracts(
    GetEmployeeContractEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(contractStatus: ProfileStatus.loading));
      final employeeContract = await employeeContractUsecase.call();
      emit(
        state.copyWith(
          contracts: employeeContract,
          contractStatus: ProfileStatus.loaded,
        ),
      );
    } catch (e) {
      log("Error while getting employee contract : $e");
      emit(
        state.copyWith(
          contractStatus: ProfileStatus.error,
          contractMessage: e.toString(),
        ),
      );
    }
  }
}
