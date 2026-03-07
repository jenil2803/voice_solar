import 'package:flutter/material.dart';

import '../../../models/dashboard_models.dart';

/// Displays net zero / sustainability metrics (CO2, coal, trees).
///
/// BACKEND: Receives [NetZeroData] from dashboard. MongoDB: consider a
/// `sustainability` or `environmental_impact` collection with these fields.
class NetZeroCard extends StatelessWidget {
  final NetZeroData data;

  const NetZeroCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
            'Net Zero Footprint',
            style: TextStyle(
              color: Color(0xFF0EA5E9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0x1A9E9E9E)),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Positioned(
                      top: 20,
                      child: _buildCircleBadge(
                          data.co2Reduced, 'co2 reduced', const Color(0xFF38BDF8), 90),
                    ),
                    Positioned(
                      bottom: 40,
                      left: 20,
                      child: _buildCircleBadge(
                          data.coalSaved, 'Coal Saved', const Color(0xFF94A3B8), 80),
                    ),
                    Positioned(
                      bottom: 60,
                      right: 10,
                      child: _buildCircleBadge(
                          data.treesPlanted, 'Trees Planted', const Color(0xFF34D399), 70),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleBadge(
      String title, String subtitle, Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withAlpha(38),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: size * 0.25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: color,
              fontSize: size * 0.12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
