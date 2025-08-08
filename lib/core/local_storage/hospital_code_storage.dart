import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class ISecureStorage {
  Future<void> saveHospitalBaseUrl(String baseUrl);
  Future<String?> getHospitalBaseUrl();
  Future<void> removeHospitalBaseUrl();

  Future<void> saveHospitalCode(String hospitalCode);
  Future<String?> getHospitalCode();
  Future<void> removeHospitalCode();
}

class HospitalCodeStorage implements ISecureStorage {
  final FlutterSecureStorage _secureStorage;

  HospitalCodeStorage(this._secureStorage);

  @override
  Future<void> saveHospitalBaseUrl(String baseUrl) async {
    await _secureStorage.write(key: 'hospital_base_url', value: baseUrl);
  }

  @override
  Future<String?> getHospitalBaseUrl() async {
    try {
      return await _secureStorage.read(key: 'base_url');
    } catch (e) {
      log("Error reading base URL: $e");
      return null;
    }
  }

  @override
  Future<void> removeHospitalBaseUrl() async {
    await _secureStorage.delete(key: 'base_url');
  }

  @override
  Future<void> saveHospitalCode(String hospitalCode) async {
    await _secureStorage.write(key: 'hospital_code', value: hospitalCode);
  }

  @override
  Future<String?> getHospitalCode() async {
    try {
      return await _secureStorage.read(key: 'hospital_code');
    } catch (e) {
      log("Error reading hospital code: $e");
      return null;
    }
  }

  @override
  Future<void> removeHospitalCode() async {
    await _secureStorage.delete(key: 'hospital_code');
  }
}
