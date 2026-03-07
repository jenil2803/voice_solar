import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/agent_service.dart';

class PlantDetailPage extends StatefulWidget {
  final String id;
  const PlantDetailPage({super.key, required this.id});

  @override
  State<PlantDetailPage> createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage> {
  Map<String, dynamic>? _plant;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final data = await AgentService.fetchPlantById(widget.id);
      setState(() { _plant = data; _loading = false; });
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
            onTap: () => context.go('/plants'),
            child: const Text(
              'Dashboard / Plants / Detail',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF0EA5E9)),
                onPressed: () => context.go('/plants'),
              ),
              const SizedBox(width: 8),
              Text(
                _plant?['name'] ?? _plant?['plant_name'] ?? 'Plant Detail',
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
          else if (_plant != null)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildInfoGrid(),
                    const SizedBox(height: 16),
                    _buildStatCard('Today Generation', '${_plant!['todayKwh'] ?? 'N/A'}', Icons.bolt, Colors.amber),
                    const SizedBox(height: 16),
                    _buildStatCard('Total Generation', '${_plant!['totalKwh'] ?? 'N/A'}', Icons.bar_chart, const Color(0xFF0EA5E9)),
                    const SizedBox(height: 16),
                    _buildStatCard('Capacity', '${_plant!['capacityKwh'] ?? 'N/A'}', Icons.solar_power, Colors.green),
                    const SizedBox(height: 16),
                    _buildStatusCard(_plant!['status'] ?? 'N/A'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid() {
    final address = [
      _plant!['address'], _plant!['city'], _plant!['state'], _plant!['country']
    ].where((v) => v != null && v.toString().isNotEmpty).join(', ');

    final items = <String, String>{
      'Installation Date': _plant!['installation_date'] ?? 'N/A',
      'Type': _plant!['plant_type'] ?? 'N/A',
      'Address': address.isNotEmpty ? address : 'N/A',
      'Last Updated': _plant!['lastUpdated'] ?? 'N/A',
    };

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF0EA5E9).withValues(alpha: 0.2)),
      ),
      child: Column(
        children: items.entries.map((e) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 140, child: Text(e.key, style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500))),
              Expanded(child: Text(e.value, style: const TextStyle(color: Color(0xFF1E293B)))),
            ],
          ),
        )).toList(),
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
              Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String status) {
    final isActive = status.toLowerCase() == 'active';
    final isAlert = status.toLowerCase() == 'alert';
    final color = isActive ? Colors.green : isAlert ? Colors.orange : Colors.red;
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
