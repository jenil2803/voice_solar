import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../models/dashboard_models.dart';

/// Displays energy generation bar chart with period selector.
class EnergyGenerationChart extends StatefulWidget {
  final EnergyChartData data;
  final Function(ChartPeriodType) onPeriodChanged;

  const EnergyGenerationChart({
    super.key,
    required this.data,
    required this.onPeriodChanged,
  });

  @override
  State<EnergyGenerationChart> createState() => _EnergyGenerationChartState();
}

class _EnergyGenerationChartState extends State<EnergyGenerationChart> {
  bool isGenerationSelected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1A9E9E9E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 24,
            runSpacing: 16,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => isGenerationSelected = true),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Energy Generation',
                          style: TextStyle(
                            color: isGenerationSelected
                                ? const Color(0xFF0EA5E9)
                                : const Color(0xFF64748B),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (isGenerationSelected)
                          Container(
                            height: 2,
                            width: 40,
                            margin: const EdgeInsets.only(top: 4),
                            color: const Color(0xFF0EA5E9),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  GestureDetector(
                    onTap: () => setState(() => isGenerationSelected = false),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Revenue',
                          style: TextStyle(
                            color: !isGenerationSelected
                                ? const Color(0xFF0EA5E9)
                                : const Color(0xFF64748B),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (!isGenerationSelected)
                          Container(
                            height: 2,
                            width: 24,
                            margin: const EdgeInsets.only(top: 4),
                            color: const Color(0xFF0EA5E9),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDropdown(widget.data.periodLabel),
                  const SizedBox(width: 12),
                  _buildToggleButtons(widget.data.periodType),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: isGenerationSelected ? widget.data.maxY : widget.data.maxY * 8,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          String text = '';
                          if (widget.data.periodType == ChartPeriodType.monthly) {
                            if (value.toInt() % 5 == 0 || value.toInt() == 1) {
                              text = value.toInt().toString();
                            }
                          } else if (widget.data.periodType == ChartPeriodType.yearly) {
                            final months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
                            if (value.toInt() >= 1 && value.toInt() <= 12) {
                              text = months[value.toInt() - 1];
                            }
                          } else {
                            text = value.toInt().toString();
                          }
  
                          if (text.isEmpty) return const SizedBox.shrink();
  
                          return Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              text,
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                        reservedSize: 32,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44,
                        getTitlesWidget: (value, meta) {
                          if (value == 0) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              isGenerationSelected
                                  ? value.toInt().toString()
                                  : '${(value / 1000).toStringAsFixed(1)}k',
                              style: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: isGenerationSelected
                        ? (widget.data.maxY / 4).clamp(1.0, double.infinity)
                        : 250,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: const Color(0xFFF1F5F9),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: widget.data.bars.map((e) {
                    double y = isGenerationSelected ? e.y : e.y * 7.5; // Use seeded rate
                    return BarChartGroupData(
                      x: e.x,
                      barRods: [
                        BarChartRodData(
                          toY: y,
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF0EA5E9),
                              const Color(0xFF38BDF8),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          width: widget.data.periodType == ChartPeriodType.monthly ? 8 : 16,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: widget.data.maxY * (isGenerationSelected ? 1 : 8),
                            color: const Color(0xFFF1F5F9),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
            ),
          ),
          if (!isGenerationSelected)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'Total Revenue: ₹ ${widget.data.bars.fold<double>(0, (sum, b) => sum + (b.y * 7.5)).toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Color(0xFF0EA5E9),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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
        border: Border.all(color: const Color(0x339E9E9E)),
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

  Widget _buildToggleButtons(ChartPeriodType currentType) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0x339E9E9E)),
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFF8FAFC),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleBtn('Monthly', currentType == ChartPeriodType.monthly, () => widget.onPeriodChanged(ChartPeriodType.monthly)),
          _buildToggleBtn('Yearly', currentType == ChartPeriodType.yearly, () => widget.onPeriodChanged(ChartPeriodType.yearly)),
          _buildToggleBtn('Lifetime', currentType == ChartPeriodType.lifetime, () => widget.onPeriodChanged(ChartPeriodType.lifetime)),
        ],
      ),
    );
  }

  Widget _buildToggleBtn(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}

