import 'package:dynamic_emr/features/attendance/domain/entities/attendance_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodayAttendanceCardWidget extends StatelessWidget {
  final List<AttendanceDetailsEntity> todaysAttendanceList;

  const TodayAttendanceCardWidget({
    super.key,
    required this.todaysAttendanceList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today Attendance',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 20),

        // Check In Card
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue[100]!),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.access_time,
                  color: Colors.blue[600],
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todaysAttendanceList.first.shiftTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      DateFormat('d MMM, yyy').format(DateTime.now()),
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Check In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 20),

        // Check In/Out Times
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.login, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Check In',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    todaysAttendanceList.first.checkInTime != null
                        ? DateFormat(
                            'hh:mm a',
                          ).format(todaysAttendanceList.first.checkInTime!)
                        : '-',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    todaysAttendanceList.first.status.toString(),
                    style: TextStyle(fontSize: 12, color: Colors.green[600]),
                  ),
                ],
              ),
            ),
            Container(height: 40, width: 1, color: Colors.grey[300]),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 8),
                      Icon(Icons.logout, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Check Out',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    todaysAttendanceList.first.checkOutTime != null
                        ? DateFormat(
                            'hh:mm a',
                          ).format(todaysAttendanceList.first.checkOutTime!)
                        : '-',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "-",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
