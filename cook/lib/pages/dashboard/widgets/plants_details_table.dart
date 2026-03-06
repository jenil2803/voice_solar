import 'package:flutter/material.dart';

import '../../../models/dashboard_models.dart';

/// Displays plants in a searchable, filterable table.
///
/// BACKEND: Receives [List<PlantDetail>] from dashboard. MongoDB: map directly
/// from `plants` collection. Each document: name, status, todayKwh, totalKwh,
/// capacityKwh, lastUpdated. Add search/filter logic that calls your API
/// (e.g. GET /api/plants?search=...&status=...).
class PlantsDetailsTable extends StatefulWidget {
  final List<PlantDetail> plants;

  const PlantsDetailsTable({super.key, required this.plants});

  @override
  State<PlantsDetailsTable> createState() => _PlantsDetailsTableState();
}

class _PlantsDetailsTableState extends State<PlantsDetailsTable> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Filters plants by search query. When backend is connected, replace
  /// with API call: GET /api/plants?search=query
  List<PlantDetail> get _filteredPlants {
    if (_searchQuery.isEmpty) return widget.plants;
    return widget.plants
        .where((p) => p.name.toLowerCase().contains(_searchQuery))
        .toList();
  }

  static Color _statusColor(PlantStatus status) {
    switch (status) {
      case PlantStatus.active:
        return const Color(0xFF22C55E);
      case PlantStatus.alert:
      case PlantStatus.expired:
        return const Color(0xFFEF4444);
      case PlantStatus.partiallyActive:
        return const Color(0xFFF59E0B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final plants = _filteredPlants;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF60A5FA).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Plants Details',
                  style: TextStyle(
                    color: Color(0xFF0EA5E9),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.tune, color: Color(0xFF0EA5E9)),
                      onPressed: () {
                        // TODO: Backend - open filter modal, call GET /api/plants?status=...
                      },
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Plants',
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFF60A5FA)),
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    columnSpacing: 24,
                    headingRowColor:
                        WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                    columns: const [
                      DataColumn(
                          label: Text('Plant Name',
                              style: TextStyle(color: Color(0xFF64748B)))),
                      DataColumn(
                          label: Text('Today',
                              style: TextStyle(color: Color(0xFF64748B)))),
                      DataColumn(
                          label: Text('Total',
                              style: TextStyle(color: Color(0xFF64748B)))),
                      DataColumn(
                          label: Text('Capacity',
                              style: TextStyle(color: Color(0xFF64748B)))),
                      DataColumn(
                          label: Text('Last Updated',
                              style: TextStyle(color: Color(0xFF64748B)))),
                    ],
                    rows: plants.map((plant) {
                      final dotColor = _statusColor(plant.status);
                      return DataRow(
                        cells: [
                          DataCell(
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: dotColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  plant.name,
                                  style:
                                      const TextStyle(color: Color(0xFF334155)),
                                ),
                              ],
                            ),
                          ),
                          DataCell(Text(plant.todayKwh,
                              style:
                                  const TextStyle(color: Color(0xFF334155)))),
                          DataCell(Text(plant.totalKwh,
                              style:
                                  const TextStyle(color: Color(0xFF334155)))),
                          DataCell(Text(plant.capacityKwh,
                              style:
                                  const TextStyle(color: Color(0xFF334155)))),
                          DataCell(Text(plant.lastUpdated,
                              style:
                                  const TextStyle(color: Color(0xFF334155)))),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
