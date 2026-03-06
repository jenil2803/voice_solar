import 'package:flutter/material.dart';

import '../../../models/dashboard_models.dart';

/// Displays device counts as a stacked bar.
///
/// BACKEND: Receives [List<DeviceCount>] from dashboard. MongoDB collection
/// `devices` could have: { type, count }. The `flex` is derived from count
/// for bar width proportion.
class TotalDevicesCard extends StatelessWidget {
  final List<DeviceCount> devices;

  const TotalDevicesCard({super.key, required this.devices});

  static const List<Color> _deviceColors = [
    Color(0xFF3B82F6),
    Color(0xFF60A5FA),
    Color(0xFF93C5FD),
    Color(0xFFDBEAFE),
  ];

  @override
  Widget build(BuildContext context) {
    final totalFlex = devices.fold<int>(0, (sum, d) => sum + d.flex);
    if (devices.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF60A5FA).withValues(alpha: 0.2)),
        ),
        child: const Center(
          child: Text(
            'No devices',
            style: TextStyle(color: Color(0xFF64748B)),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF60A5FA).withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Devices',
            style: TextStyle(
              color: Color(0xFF0EA5E9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            clipBehavior: Clip.antiAlias,
            child: Row(
              children: devices.asMap().entries.map((e) {
                final flex = totalFlex > 0 ? e.value.flex : 1;
                final color = _deviceColors[e.key % _deviceColors.length];
                return Expanded(
                    flex: flex, child: Container(color: color));
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: devices.asMap().entries.map((e) {
              final color = _deviceColors[e.key % _deviceColors.length];
              return Text(
                '${e.value.type} - ${e.value.count}',
                style: TextStyle(color: color, fontSize: 12),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
