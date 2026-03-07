import 'package:flutter/material.dart';
import '../../models/dashboard_models.dart';
import '../../services/dashboard_service.dart';

class InvertersPage extends StatefulWidget {
  const InvertersPage({super.key});

  @override
  State<InvertersPage> createState() => _InvertersPageState();
}

class _InvertersPageState extends State<InvertersPage> {
  final DashboardService _service = DashboardService();
  late Future<List<InverterDetail>> _invertersFuture;

  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Filter state
  Set<String> _selectedCategories = {};
  Set<String> _selectedManufacturers = {};
  
  // Available filter options (derived from data)
  List<String> _availableCategories = [];
  List<String> _availableManufacturers = [];

  @override
  void initState() {
    super.initState();
    _invertersFuture = _service.getInverters();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          const Text(
            'Dashboard / Inverters',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),

          FutureBuilder<List<InverterDetail>>(
            future: _invertersFuture,
            builder: (context, snapshot) {
              int totalCount = snapshot.data?.length ?? 0;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Inverters',
                        style: TextStyle(
                          color: Color(0xFF0EA5E9),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '($totalCount)',
                        style: TextStyle(
                          color: const Color(0xFF0EA5E9).withAlpha(180),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          if (snapshot.hasData) {
                            _showFilterDialog(context, snapshot.data!);
                          }
                        },
                        icon: const Icon(Icons.filter_alt_outlined,
                            color: Color(0xFF0EA5E9)),
                        label: const Text(
                          'Filter',
                          style: TextStyle(color: Color(0xFF0EA5E9)),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: const Color(0xFF0EA5E9).withAlpha(80)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 250,
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search Devices',
                            hintStyle:
                                const TextStyle(color: Color(0xFF94A3B8)),
                            prefixIcon: const Icon(Icons.search,
                                color: Color(0xFF94A3B8)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.withAlpha(50),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.withAlpha(50),
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Main Table Content
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF0EA5E9).withAlpha(80),
                ),
              ),
              child: Column(
                children: [
                  // Table Header
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9).withAlpha(128),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: const Color(0xFF0EA5E9).withAlpha(80),
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 24),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Device Name',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Category',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Manufacturer',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Today Generation',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Total Generation',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Last Updated',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Table Body (Scrollable)
                  Expanded(
                    child: FutureBuilder<List<InverterDetail>>(
                      future: _invertersFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No inverters available.'));
                        }

                        final allInverters = snapshot.data!;
                        final filteredInverters = allInverters.where((inv) {
                          final nameMatch = inv.deviceName.toLowerCase().contains(_searchQuery);
                          final makerMatch = inv.manufacturer.toLowerCase().contains(_searchQuery);
                          final searchMatch = nameMatch || makerMatch;
                          
                          final categoryMatch = _selectedCategories.isEmpty || _selectedCategories.contains(inv.category);
                          final manufacturerMatch = _selectedManufacturers.isEmpty || _selectedManufacturers.contains(inv.manufacturer);
                          
                          return searchMatch && categoryMatch && manufacturerMatch;
                        }).toList();

                        if (filteredInverters.isEmpty) {
                          return const Center(
                              child: Text('No matching inverters.'));
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: filteredInverters.length,
                          itemBuilder: (context, index) {
                            final inv = filteredInverters[index];
                            final statusColor = inv.status == PlantStatus.active
                                ? Colors.green
                                : inv.status == PlantStatus.alert
                                    ? Colors.red
                                    : Colors.orange;

                            return _buildTableRow(
                              deviceName: inv.deviceName,
                              category: inv.category,
                              manufac: inv.manufacturer,
                              todayGen: '${inv.todayGeneration} Kwh',
                              totalGen: '${inv.totalGeneration} Kwh',
                              lastUpdated: inv.lastUpdated,
                              statusColor: statusColor,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow({
    required String deviceName,
    required String category,
    required String manufac,
    required String todayGen,
    required String totalGen,
    required String lastUpdated,
    required Color statusColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  deviceName,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              category,
              style: const TextStyle(color: Color(0xFF475569)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              manufac,
              style: const TextStyle(color: Color(0xFF475569)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              todayGen,
              style: const TextStyle(color: Color.fromARGB(255, 21, 236, 78)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              totalGen,
              style: const TextStyle(color: Color.fromARGB(255, 21, 236, 78)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              lastUpdated,
              style: const TextStyle(color: Color(0xFF475569)),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context, List<InverterDetail> inverters) {
    if (_availableCategories.isEmpty) {
      _availableCategories = inverters.map((e) => e.category).toSet().toList()..sort();
      _availableManufacturers = inverters.map((e) => e.manufacturer).toSet().toList()..sort();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filter Inverters'),
              titlePadding: const EdgeInsets.all(24).copyWith(bottom: 0),
              contentPadding: const EdgeInsets.all(24),
              content: SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _availableCategories.map((cat) {
                          final isSelected = _selectedCategories.contains(cat);
                          return FilterChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (selected) {
                              setDialogState(() {
                                if (selected) {
                                  _selectedCategories.add(cat);
                                } else {
                                  _selectedCategories.remove(cat);
                                }
                              });
                            },
                            selectedColor: const Color(0xFF0EA5E9).withValues(alpha: 0.2),
                            checkmarkColor: const Color(0xFF0EA5E9),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      const Text('Manufacturer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _availableManufacturers.map((mfg) {
                          final isSelected = _selectedManufacturers.contains(mfg);
                          return FilterChip(
                            label: Text(mfg),
                            selected: isSelected,
                            onSelected: (selected) {
                              setDialogState(() {
                                if (selected) {
                                  _selectedManufacturers.add(mfg);
                                } else {
                                  _selectedManufacturers.remove(mfg);
                                }
                              });
                            },
                             selectedColor: const Color(0xFF0EA5E9).withValues(alpha: 0.2),
                             checkmarkColor: const Color(0xFF0EA5E9),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.all(24).copyWith(top: 0),
              actions: [
                TextButton(
                  onPressed: () {
                    setDialogState(() {
                      _selectedCategories.clear();
                      _selectedManufacturers.clear();
                    });
                  },
                  child: const Text('Clear', style: TextStyle(color: Color(0xFF64748B))),
                ),
                FilledButton(
                  onPressed: () {
                    // Update main state to trigger rebuild of ListView
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0EA5E9)),
                  child: const Text('Apply Details'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
