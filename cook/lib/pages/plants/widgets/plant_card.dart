import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PlantCard extends StatelessWidget {
  final String plantName;
  final String timeAgo;
  final bool isActive;
  final String todayKwh;
  final String totalKwh;
  final String devices;
  final bool hasData;

  const PlantCard({
    super.key,
    required this.plantName,
    required this.timeAgo,
    this.isActive = true,
    required this.todayKwh,
    required this.totalKwh,
    required this.devices,
    this.hasData = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plantName,
                    style: const TextStyle(
                      color: Color(0xFF0EA5E9),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeAgo,
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isActive ? 'Active' : 'Offline',
                    style: TextStyle(
                      color: isActive ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat('Today', todayKwh),
              _buildStat('Total', totalKwh),
              _buildStat('Devices', devices, isNumberMap: true),
              const SizedBox(width: 24), // spacing
            ],
          ),
          const SizedBox(height: 24),
          if (hasData) ...[
            const Text('Active Power', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Color(0x339E9E9E),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          const times = ['00:00', '2:00', '3:00', '00:00', '2:00', '3:00', '00:00', '2:00'];
                          if (value.toInt() >= 0 && value.toInt() < times.length) {
                            return Text(times[value.toInt()], style: const TextStyle(color: Colors.grey, fontSize: 10));
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          if (value == 0 || value == 10 || value == 30 || value == 50) {
                            return Text(value.toInt().toString(), style: const TextStyle(color: Colors.grey, fontSize: 10));
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 7,
                  minY: 0,
                  maxY: 60,
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 5),
                        FlSpot(1, 10),
                        FlSpot(2, 15),
                        FlSpot(3, 20),
                        FlSpot(4, 35),
                        FlSpot(5, 45),
                        FlSpot(6, 50),
                        FlSpot(7, 52),
                      ],
                      isCurved: true,
                      color: const Color(0xFF3B82F6),
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9), // slightly darker gray
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0x1A9E9E9E)),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart, color: Color(0xFFCBD5E1), size: 48),
                    SizedBox(height: 8),
                    Text('Data will appear here\nWhen Available', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                  ],
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, {bool isNumberMap = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF0EA5E9),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
