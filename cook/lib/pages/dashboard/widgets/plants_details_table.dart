import 'package:flutter/material.dart';

import '../../../models/dashboard_models.dart';
import '../../plants/plant_details_page.dart';

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
  final Set<PlantStatus> _selectedStatuses = {
    PlantStatus.active,
    PlantStatus.alert,
    PlantStatus.partiallyActive,
    PlantStatus.expired
  };

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

  List<PlantDetail> get _filteredPlants {
    return widget.plants.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery);
      final matchesStatus = _selectedStatuses.contains(p.status);
      return matchesSearch && matchesStatus;
    }).toList();
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
          color: const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                const Text(
                  'Plants Details',
                  style: TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                PopupMenuButton<PlantStatus>(
                  icon: Icon(
                    Icons.tune,
                    color: _selectedStatuses.length < 4
                        ? const Color(0xFF0EA5E9)
                        : const Color(0xFF64748B),
                  ),
                  tooltip: 'Filter by Status',
                  onSelected: (status) {
                    setState(() {
                      if (_selectedStatuses.contains(status)) {
                        if (_selectedStatuses.length > 1) {
                          _selectedStatuses.remove(status);
                        }
                      } else {
                        _selectedStatuses.add(status);
                      }
                    });
                  },
                  itemBuilder: (context) {
                    return PlantStatus.values.map((status) {
                      final isSelected = _selectedStatuses.contains(status);
                      return CheckedPopupMenuItem<PlantStatus>(
                        value: status,
                        checked: isSelected,
                        child: Text(status.name[0].toUpperCase() + status.name.substring(1)),
                      );
                    }).toList();
                  },
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 240,
                  height: 40,
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search plants...',
                      hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                      prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF94A3B8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
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
                    showCheckboxColumn: false,
                    headingRowColor:
                        WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                    columns: const [
                      DataColumn(
                          label: Text('Plant Name',
                              style: TextStyle(color: Color(0xFF64748B)))),
                      DataColumn(
                          label: Text('Location',
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
                      return DataRow(
                        onSelectChanged: (selected) {
                          if (selected == true || selected == false) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlantDetailsPage(plant: plant),
                              ),
                            );
                          }
                        },
                        cells: [
                          DataCell(Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _statusColor(plant.status),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(plant.name,
                                  style: const TextStyle(
                                      color: Color(0xFF334155),
                                      fontWeight: FontWeight.w500)),
                            ],
                          )),
                          DataCell(Text('${plant.city}, ${plant.state}',
                              style:
                                  const TextStyle(color: Color(0xFF64748B)))),
                          DataCell(Text(plant.todayKwh,
                              style:
                                  const TextStyle(color: Color(0xFF64748B)))),
                          DataCell(Text(plant.totalKwh,
                              style:
                                  const TextStyle(color: Color(0xFF64748B)))),
                          DataCell(Text(plant.capacityKwh,
                              style:
                                  const TextStyle(color: Color(0xFF64748B)))),
                          DataCell(Text(plant.lastUpdated,
                              style:
                                  const TextStyle(color: Color(0xFF64748B)))),
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
