import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class EnergyGenerationChart extends StatefulWidget {
  const EnergyGenerationChart({super.key});

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
          Row(
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
              const Spacer(),
              _buildDropdown('September 2026'),
              const SizedBox(width: 12),
              _buildToggleButtons(),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {},
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
                maxY: isGenerationSelected ? 40 : 1000,
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
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          isGenerationSelected
                              ? value.toInt().toString()
                              : '${value.toInt()}',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
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
                  horizontalInterval: isGenerationSelected ? 10 : 250,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: const Color(0x339E9E9E),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  22,
                  (i) {
                    double y;
                    if (isGenerationSelected) {
                      y = (i == 19) ? 38 : (20 + (i % 5) * 4).toDouble();
                    } else {
                      y = (i == 19) ? 900 : (400 + (i % 5) * 100).toDouble();
                    }
                    return BarChartGroupData(
                      x: i + 1,
                      barRods: [
                        BarChartRodData(
                          toY: y,
                          color: (i == 19 || i == 18)
                              ? const Color(0xFF3B82F6)
                              : const Color(0xFFBAE6FD),
                          width: 8,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          if (!isGenerationSelected)
             Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Total Revenue: ₹ 2,45,670',
                style: TextStyle(
                  color: const Color(0xFF0EA5E9),
                  fontSize: 14,
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

  Widget _buildToggleButtons() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0x339E9E9E)),
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFF8FAFC),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleBtn('Monthly', false),
          _buildToggleBtn('Yearly', true),
          _buildToggleBtn('Lifetime', false),
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
