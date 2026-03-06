import 'package:flutter/material.dart';

class NetZeroCard extends StatelessWidget {
  const NetZeroCard({super.key});

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
                    // Grid background
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0x1A9E9E9E)),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Positioned(
                      top: 20,
                      child: _buildCircleBadge('1.03k', 'co2 reduced', const Color(0xFF38BDF8), 90),
                    ),
                    Positioned(
                      bottom: 40,
                      left: 20,
                      child: _buildCircleBadge('1.4 T', 'Coal Saved', const Color(0xFF94A3B8), 80),
                    ),
                    Positioned(
                      bottom: 60,
                      right: 10,
                      child: _buildCircleBadge('155K', 'Trees Planted', const Color(0xFF34D399), 70),
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

  Widget _buildCircleBadge(String title, String subtitle, Color color, double size) {
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
