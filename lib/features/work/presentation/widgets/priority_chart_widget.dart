import 'package:dynamic_emr/features/work/domain/entities/ticket_summary_entity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PriorityChartWidget extends StatelessWidget {
  final TicketSummaryEntity ticketSummary;
  const PriorityChartWidget({super.key, required this.ticketSummary});

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
            'Priority',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 120,
            child:
                (ticketSummary.severityHigh +
                        ticketSummary.severityMedium +
                        ticketSummary.severityLow) >
                    0
                ? BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY:
                          [
                            ticketSummary.severityHigh,
                            ticketSummary.severityMedium,
                            ticketSummary.severityLow,
                          ].reduce((a, b) => a > b ? a : b).toDouble() *
                          1.2,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              switch (value.toInt()) {
                                case 0:
                                  return Text(
                                    'H',
                                    style: TextStyle(fontSize: 10),
                                  );
                                case 1:
                                  return Text(
                                    'M',
                                    style: TextStyle(fontSize: 10),
                                  );
                                case 2:
                                  return Text(
                                    'L',
                                    style: TextStyle(fontSize: 10),
                                  );
                                default:
                                  return Text('');
                              }
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: ticketSummary.severityHigh.toDouble(),
                              color: Color(0xFFEF4444),
                              width: 20,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              toY: ticketSummary.severityMedium.toDouble(),
                              color: Color(0xFFF59E0B),
                              width: 20,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 2,
                          barRods: [
                            BarChartRodData(
                              toY: ticketSummary.severityLow.toDouble(),
                              color: Color(0xFF10B981),
                              width: 20,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      'No data',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
