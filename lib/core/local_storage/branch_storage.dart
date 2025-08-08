import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class BranchSecureStorage {
  Future<void> saveWorkingBranchId(String branchId);
  Future<String?> getWorkingBranchId();
  Future<void> saveSelectedFiscalFiscalYearId(String fiscalyear);
  Future<String?> getSelectedFiscalFiscalYearId();
  Future<void> removeWorkingBranchId();
  Future<void> removeSelectedFiscalFiscalYearId();
}

class BranchStorage implements BranchSecureStorage {
  final FlutterSecureStorage _secureStorage;

  BranchStorage(this._secureStorage);
  // Store branch ID
  @override
  Future<void> saveWorkingBranchId(String branchId) async {
    await _secureStorage.write(
      key: 'selected_workingbranchId',
      value: branchId,
    );
  }

  // Retrieve branch ID
  @override
  Future<String?> getWorkingBranchId() async {
    try {
      return await _secureStorage.read(key: 'selected_workingbranchId');
    } catch (e) {
      log("Error reading branch ID: $e");
      return null;
    }
  }

  @override
  Future<void> saveSelectedFiscalFiscalYearId(String fiscalyear) async {
    await _secureStorage.write(
      key: 'selected_fiscal_year_id',
      value: fiscalyear,
    );
  }

  @override
  Future<String?> getSelectedFiscalFiscalYearId() async {
    try {
      return await _secureStorage.read(key: 'selected_fiscal_year_id');
    } catch (e) {
      log("Error reading branch ID: $e");
      return null;
    }
  }

  @override
  Future<void> removeSelectedFiscalFiscalYearId() async {
    await _secureStorage.delete(key: 'selected_fiscal_year_id');
  }

  @override
  Future<void> removeWorkingBranchId() async {
    await _secureStorage.delete(key: 'selected_workingbranchId');
  }
}
