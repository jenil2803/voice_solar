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
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: 40,
            bottom: 0,
            width: 160,
            child: Opacity(
              opacity: 0.5,
              child: CustomPaint(
                painter: DottedMapPainter(),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Plants Status',
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${data.totalPlants}',
                    style: const TextStyle(
                      color: Color(0xFF0EA5E9),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text(
                      'Total Plants',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 24,
                runSpacing: 16,
                children: [
                  _buildStat('${data.active}', 'Active', const Color(0xFF22C55E)),
                  _buildStat('${data.alert}', 'Alert', const Color(0xFFEF4444)),
                  _buildStat('${data.partiallyActive}', 'Partial', const Color(0xFFF59E0B)),
                  _buildStat('${data.expired}', 'Expired', const Color(0xFF94A3B8)),
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
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              number,
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
        ),
      ],
    );
  }
}
class DottedMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF94A3B8).withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    const double spacing = 10.0;
    const double dotSize = 2.0;

    // Define a rough shape of Gujarat using points
    // This is a simplified representation to mimic the design
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        // Simple heuristic to create a "map-like" blob
        // Normalized coordinates
        double nx = x / size.width;
        double ny = y / size.height;

        bool shouldDraw = false;

        // Roughly the shape of Gujarat: wide at top, narrower bottom, sticking out left
        if (ny < 0.3) {
          if (nx > 0.3 && nx < 0.9) shouldDraw = true;
        } else if (ny < 0.6) {
          if (nx > 0.1 && nx < 0.8) shouldDraw = true;
        } else if (ny < 0.8) {
          if (nx > 0.4 && nx < 0.7) shouldDraw = true;
        }

        if (shouldDraw) {
          canvas.drawCircle(Offset(x, y), dotSize, paint);
        }
      }
    }

    // Add a few colorful dots as state indicators like in design
    final redPaint = Paint()..color = const Color(0xFFEF4444);
    final orangePaint = Paint()..color = const Color(0xFFF59E0B);
    final bluePaint = Paint()..color = const Color(0xFF3B82F6);

    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.4), 3, redPaint);
    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.25), 3, orangePaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.55), 3, bluePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
