import 'dart:async';
import 'dart:developer';

import 'package:dynamic_emr/features/profile/domain/entities/employee_entity.dart';
import 'package:dynamic_emr/features/profile/domain/usecases/employee_details_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final EmployeeDetailsUsecase employeeDetailsUsecase;
  ProfileBloc({required this.employeeDetailsUsecase})
    : super(ProfileInitialState()) {
    on<GetEmployeeDetailsEvent>(_onGetEmployeeDetailsEvent);
  }

  Future<void> _onGetEmployeeDetailsEvent(
    GetEmployeeDetailsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoadingState());
      final employeeDetails = await employeeDetailsUsecase.call();
      emit(ProfileLoadedState(employee: employeeDetails));
    } catch (e) {
      log("Error while getting employee details (profile) : $e");
    }
  }
}
