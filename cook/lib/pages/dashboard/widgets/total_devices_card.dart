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
    Color(0xFF0EA5E9),
    Color(0xFF6366F1),
    Color(0xFFF59E0B),
    Color(0xFF22C55E),
  ];

  @override
  Widget build(BuildContext context) {
    final totalFlex = devices.fold<int>(0, (sum, d) => sum + d.flex);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Devices',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          if (devices.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'No devices found',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                ),
              ),
            )
          else ...[
            Container(
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: const Color(0xFFF1F5F9),
              ),
              clipBehavior: Clip.antiAlias,
              child: Row(
                children: devices.asMap().entries.map((e) {
                  final flex = totalFlex > 0 ? e.value.flex : 1;
                  final color = _deviceColors[e.key % _deviceColors.length];
                  return Expanded(
                    flex: flex,
                    child: Container(color: color),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 20,
              runSpacing: 12,
              children: devices.asMap().entries.map((e) {
                final color = _deviceColors[e.key % _deviceColors.length];
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      e.value.type,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${e.value.count}',
                      style: const TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
