import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/agent_service.dart';

class SensorDetailPage extends StatefulWidget {
  final String id;
  const SensorDetailPage({super.key, required this.id});

  @override
  State<SensorDetailPage> createState() => _SensorDetailPageState();
}

class _SensorDetailPageState extends State<SensorDetailPage> {
  Map<String, dynamic>? _sensor;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final data = await AgentService.fetchSensorById(widget.id);
      setState(() { _sensor = data; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          GestureDetector(
            onTap: () => context.go('/sensors'),
            child: const Text(
              'Dashboard / Sensors / Detail',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF0EA5E9)),
                onPressed: () => context.go('/sensors'),
              ),
              const SizedBox(width: 8),
              Text(
                _sensor?['device_name'] ?? 'Sensor Detail',
                style: const TextStyle(
                  color: Color(0xFF0EA5E9),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          if (_loading)
            const Expanded(child: Center(child: CircularProgressIndicator(color: Color(0xFF0EA5E9))))
          else if (_error != null)
            Expanded(child: Center(child: Text('Error: $_error', style: const TextStyle(color: Colors.red))))
          else if (_sensor != null)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildStatCard('Sensor Type', '${_sensor!['sensor_type'] ?? 'N/A'}', Icons.sensors, const Color(0xFF0EA5E9)),
                    const SizedBox(height: 16),
                    _buildStatCard('Manufacturer', '${_sensor!['manufacturer'] ?? 'N/A'}', Icons.factory, Colors.purple),
                    const SizedBox(height: 16),
                    _buildStatCard('Plant ID', '${_sensor!['plant_id'] ?? 'N/A'}', Icons.solar_power, Colors.teal),
                    const SizedBox(height: 16),
                    _buildStatusCard(_sensor!['status'] ?? 'N/A'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String status) {
    final isActive = status.toLowerCase() == 'active';
    final color = isActive ? Colors.green : status.toLowerCase() == 'alert' ? Colors.orange : Colors.red;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 16),
          Text('Status: $status', style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
