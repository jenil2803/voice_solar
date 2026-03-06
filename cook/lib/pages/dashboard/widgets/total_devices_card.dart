import 'package:flutter/material.dart';

class TotalDevicesCard extends StatelessWidget {
  const TotalDevicesCard({super.key});

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
            'Total Devices',
            style: TextStyle(
              color: Color(0xFF0EA5E9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          // Stacked Bar Placeholder
          Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            clipBehavior: Clip.antiAlias,
            child: Row(
              children: [
                Expanded(flex: 5, child: Container(color: const Color(0xFF3B82F6))),
                Expanded(flex: 1, child: Container(color: const Color(0xFF60A5FA))),
                Expanded(flex: 2, child: Container(color: const Color(0xFF93C5FD))),
                Expanded(flex: 4, child: Container(color: const Color(0xFFDBEAFE))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('MFM - 5', style: TextStyle(color: Color(0xFF3B82F6), fontSize: 12)),
              Text('WFM - 1', style: TextStyle(color: Color(0xFF60A5FA), fontSize: 12)),
              Text('SLMS - 2', style: TextStyle(color: Color(0xFF93C5FD), fontSize: 12)),
              Text('Inverters - 4', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }
}
