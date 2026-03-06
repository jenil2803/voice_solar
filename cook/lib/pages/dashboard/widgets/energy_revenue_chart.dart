import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../models/dashboard_models.dart';

/// Displays energy generation bar chart with period selector.
///
/// BACKEND: Receives [EnergyChartData] from dashboard. MongoDB: aggregate
/// `energy_readings` or `readings` by date range. When user changes period,
/// call [DashboardService.getChartData] with new period - replace that
/// method to hit your API endpoint (e.g. GET /api/chart?period=monthly).
class EnergyGenerationChart extends StatelessWidget {
  final EnergyChartData data;

  const EnergyGenerationChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0x1A9E9E9E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Energy Generation',
                style: TextStyle(
                  color: Color(0xFF0EA5E9),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 24),
              const Text(
                'Revenue',
                style: TextStyle(
                  color: Color(0xFF0EA5E9),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              _buildDropdown(data.periodLabel),
              const SizedBox(width: 12),
              _buildToggleButtons(data.periodType),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {
                  // TODO: Backend - add export/download endpoint
                },
                icon: const Icon(Icons.download, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF60A5FA),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              )
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: data.maxY,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Color(0x339E9E9E),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: data.bars.asMap().entries.map((e) {
                  final isHighlight = e.key == data.bars.length - 3;
                  return BarChartGroupData(
                    x: e.value.x,
                    barRods: [
                      BarChartRodData(
                        toY: e.value.y,
                        color: isHighlight
                            ? const Color(0xFF3B82F6)
                            : const Color(0xFFBAE6FD),
                        width: 8,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0x339E9E9E)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.chevron_left, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildToggleButtons(ChartPeriodType type) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0x339E9E9E)),
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFF8FAFC),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleBtn('Monthly', type == ChartPeriodType.monthly),
          _buildToggleBtn('Yearly', type == ChartPeriodType.yearly),
          _buildToggleBtn('Lifetime', type == ChartPeriodType.lifetime),
        ],
      ),
    );
  }

  Widget _buildToggleBtn(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: isSelected
          ? BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? const Color(0xFF0EA5E9) : Colors.grey,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
