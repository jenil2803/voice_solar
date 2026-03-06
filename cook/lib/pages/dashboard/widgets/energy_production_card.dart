import 'package:flutter/material.dart';

import '../../../models/dashboard_models.dart';

/// Displays energy production gauge and stats.
///
/// BACKEND: Receives [EnergyProductionData] from dashboard. When connected to
/// MongoDB, ensure your API returns: todayKwh, percentage, totalProduction, totalCapacity.
class EnergyProductionCard extends StatelessWidget {
  final EnergyProductionData data;

  const EnergyProductionCard({super.key, required this.data});

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
          const Text(
            'Total Energy Production',
            style: TextStyle(
              color: Color(0xFF0EA5E9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              height: 150,
              width: 250,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(125),
                        topRight: Radius.circular(125),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data.todayKwh,
                        style: const TextStyle(
                            color: Color(0xFF0EA5E9), fontSize: 14),
                      ),
                      Text(
                        '${data.percentage.toStringAsFixed(2)}%',
                        style: const TextStyle(
                          color: Color(0xFF0EA5E9),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Today\'s generation',
                        style: TextStyle(
                            color: Color(0xFF64748B), fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat('Total Production', data.totalProduction),
              _buildStat('Total Capacity', data.totalCapacity),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF0EA5E9),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
