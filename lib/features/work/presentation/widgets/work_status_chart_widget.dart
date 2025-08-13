import 'package:dynamic_emr/features/work/domain/entities/ticket_summary_entity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WorkStatusChartWidget extends StatelessWidget {
  final TicketSummaryEntity ticketSummary;
  const WorkStatusChartWidget({super.key, required this.ticketSummary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ticket Status Distribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 200,
            child:
                (ticketSummary.open +
                        ticketSummary.inProgress +
                        ticketSummary.closed) >
                    0
                ? PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 50,
                      sections: [
                        PieChartSectionData(
                          color: Color(0xFFEF4444),
                          value: ticketSummary.open.toDouble(),
                          title: '${ticketSummary.open}',
                          titleStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          color: Color(0xFFF59E0B),
                          value: ticketSummary.inProgress.toDouble(),
                          title: '${ticketSummary.inProgress}',
                          titleStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          color: Color(0xFF10B981),
                          value: ticketSummary.closed.toDouble(),
                          title: '${ticketSummary.closed}',
                          titleStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem('Open', Color(0xFFEF4444)),
              _buildLegendItem('In Progress', Color(0xFFF59E0B)),
              _buildLegendItem('Closed', Color(0xFF10B981)),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildLegendItem(String label, Color color) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      SizedBox(width: 6),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}
