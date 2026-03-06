import 'package:flutter/material.dart';

class EnergyProductionCard extends StatelessWidget {
  const EnergyProductionCard({super.key});

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
          // Semicircle gauge placeholder
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
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '20 kWh',
                        style: TextStyle(color: Color(0xFF0EA5E9), fontSize: 14),
                      ),
                      Text(
                        '50.75%',
                        style: TextStyle(
                          color: Color(0xFF0EA5E9),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Today\'s generation',
                        style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
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
              _buildStat('Total Production', '42.8 kWh'),
              _buildStat('Total Capacity', '42.8 kWh'),
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
          Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Color(0xFF0EA5E9), fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
