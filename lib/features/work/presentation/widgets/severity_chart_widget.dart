import 'package:dynamic_emr/features/work/domain/entities/ticket_summary_entity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SeverityChartWidget extends StatelessWidget {
  final TicketSummaryEntity ticketSummary;
  const SeverityChartWidget({super.key, required this.ticketSummary});

  @override
  Widget build(BuildContext context) {
    final maxY =
        [
          ticketSummary.severityHigh,
          ticketSummary.severityMedium,
          ticketSummary.severityLow,
        ].reduce((a, b) => a > b ? a : b).toDouble() *
        1.2;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Severity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
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
                      maxY: maxY,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              switch (value.toInt()) {
                                case 0:
                                  return Text(
                                    'H [${ticketSummary.severityHigh}]',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 10),
                                  );
                                case 1:
                                  return Text(
                                    'M [${ticketSummary.severityMedium}]',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 10),
                                  );
                                case 2:
                                  return Text(
                                    'L [${ticketSummary.severityLow}]',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 10),
                                  );
                                default:
                                  return Text('');
                              }
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: (maxY / 5).ceilToDouble(),
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        horizontalInterval: (maxY / 5).ceilToDouble(),
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.grey.withValues(alpha: 0.2),
                          strokeWidth: 1,
                        ),
                      ),
                      barGroups: [
                        _makeBar(
                          0,
                          ticketSummary.severityHigh.toDouble(),
                          Color(0xFFEF4444),
                        ),
                        _makeBar(
                          1,
                          ticketSummary.severityMedium.toDouble(),
                          Color(0xFFF59E0B),
                        ),
                        _makeBar(
                          2,
                          ticketSummary.severityLow.toDouble(),
                          Color(0xFF10B981),
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

  BarChartGroupData _makeBar(int x, double value, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: color,
          width: 20,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
