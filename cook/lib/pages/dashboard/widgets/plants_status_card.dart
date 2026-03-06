import 'package:flutter/material.dart';

import '../../../models/dashboard_models.dart';

/// Displays plants status breakdown (total, active, alert, etc.).
///
/// BACKEND: Receives [PlantsStatusData] from dashboard. MongoDB: aggregate
/// from `plants` collection by status field. Status values: active, alert,
/// partiallyActive, expired.
class PlantsStatusCard extends StatelessWidget {
  final PlantsStatusData data;

  const PlantsStatusCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 20,
            bottom: 20,
            width: 150,
            child: Opacity(
              opacity: 0.1,
              child: const Center(child: Icon(Icons.map, size: 100)),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Plants Status',
                style: TextStyle(
                  color: Color(0xFF0EA5E9),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                '${data.totalPlants}',
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              const Text(
                'Total Plants',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _buildStat('${data.active}', 'Active', const Color(0xFF3B82F6)),
                  const SizedBox(width: 32),
                  _buildStat('${data.alert}', 'Alert', const Color(0xFFEF4444)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildStat('${data.partiallyActive}', 'Partially Active',
                      const Color(0xFFF59E0B)),
                  const SizedBox(width: 32),
                  _buildStat('${data.expired}', 'Expired', const Color(0xFFEF4444)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String number, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: color.withAlpha(204), fontSize: 12),
        ),
      ],
    );
  }
}
