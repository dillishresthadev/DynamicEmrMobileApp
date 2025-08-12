import 'package:intl/intl.dart';

extension DateFormatter1 on DateTime {
  String toYyyyMmmDd() {
    // e.g. 2025-08-12
return DateFormat('yyyy-MM-dd').format(this);
  }
}

extension DateFormatter2 on DateTime {
  String toDMMMYYYY() {
    // e.g. 12, Aug 2025
    return DateFormat('d, MMM yyyy').format(this);
  }
}
extension DateFormatter3 on DateTime {
  String toMMDDYYY() {
    // e.g. 08/12/2025
    return DateFormat('MM/dd/yyyy').format(this);
  }
}
