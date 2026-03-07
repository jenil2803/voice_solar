import 'package:flutter/material.dart';
import '../../models/dashboard_models.dart';
import '../../services/dashboard_service.dart';
import 'widgets/plant_card.dart';

class PlantsPage extends StatefulWidget {
  const PlantsPage({super.key});

  @override
  State<PlantsPage> createState() => _PlantsPageState();
}

class _PlantsPageState extends State<PlantsPage> {
  final DashboardService _service = DashboardService();
  late Future<List<PlantDetail>> _plantsFuture;

  String _searchQuery = '';
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _plantsFuture = _service.getPlants();
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: FutureBuilder<List<PlantDetail>>(
          future: _plantsFuture,
          builder: (context, snapshot) {
            final allPlants = snapshot.data ?? [];
            final filteredPlants = allPlants.where((p) {
              bool matchesSearch = p.name.toLowerCase().contains(_searchQuery);
              bool matchesStatus = true;
              if (_selectedFilter == 'Active') {
                matchesStatus = p.status == PlantStatus.active;
              } else if (_selectedFilter == 'Offline') {
                matchesStatus = p.status != PlantStatus.active;
              }
              return matchesSearch && matchesStatus;
            }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: 'Dashboard / ',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                    children: [
                      TextSpan(
                        text: 'Plants',
                        style: TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Plants',
                          style: TextStyle(
                            color: Color(0xFF0EA5E9),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${filteredPlants.length})',
                          style: TextStyle(
                            color: const Color(0xB30EA5E9),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        PopupMenuButton<String>(
                          onSelected: (val) {
                            setState(() => _selectedFilter = val);
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: 'All', child: Text('All Plants')),
                            PopupMenuItem(value: 'Active', child: Text('Active Only')),
                            PopupMenuItem(value: 'Offline', child: Text('Offline Only')),
                          ],
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFF0EA5E9)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.filter_alt_outlined, color: Color(0xFF0EA5E9), size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  _selectedFilter == 'All' ? 'Filter' : _selectedFilter,
                                  style: const TextStyle(color: Color(0xFF0EA5E9), fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0x339E9E9E)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.grid_view,
                                  color: Color(0xFF0EA5E9), size: 20),
                              SizedBox(width: 12),
                              Icon(Icons.public,
                                  color: Color(0xFF0EA5E9), size: 20),
                            ],
                          ),
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
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0x339E9E9E)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0x339E9E9E)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 32),
                
                // Content Area
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Center(child: CircularProgressIndicator())
                else if (snapshot.hasError)
                  Center(child: Text('Error: ${snapshot.error}'))
                else if (filteredPlants.isEmpty)
                  const Center(child: Text('No matching plants found.'))
                else
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 1200
                          ? 3
                          : (constraints.maxWidth > 800 ? 2 : 1);
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio:
                              constraints.maxWidth > 1200 ? 1.4 : 1.2,
                        ),
                        itemCount: filteredPlants.length,
                        itemBuilder: (context, index) {
                          final plant = filteredPlants[index];
                          return PlantCard(
                            plantName: plant.name,
                            timeAgo: plant.lastUpdated,
                            isActive: plant.status == PlantStatus.active,
                            todayKwh: plant.todayKwh,
                            totalKwh: plant.totalKwh,
                            devices: '55', 
                            hasData: true,
                          );
                        },
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add Plant capability coming soon!')),
          );
        },
        backgroundColor: const Color(0xFF3B82F6),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}
