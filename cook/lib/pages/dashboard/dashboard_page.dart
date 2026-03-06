import 'package:flutter/material.dart';

import '../../models/dashboard_models.dart';
import '../../services/dashboard_service.dart';
import 'widgets/energy_production_card.dart';
import 'widgets/total_devices_card.dart';
import 'widgets/plants_status_card.dart';
import 'widgets/net_zero_card.dart';
import 'widgets/energy_revenue_chart.dart';
import 'widgets/plants_details_table.dart';

/// Dashboard page - fetches data from [DashboardService] and passes to widgets.
///
/// BACKEND: Data flows from [DashboardService.getDashboardData].
/// When MongoDB is connected, that method will call your API instead of mock data.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardService _dashboardService = DashboardService();

  DashboardData? _data;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Fetches dashboard data. Called on init and can be used for pull-to-refresh.
  /// BACKEND: This triggers [DashboardService.getDashboardData] - replace that
  /// method's implementation to call your MongoDB/API.
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _dashboardService.getDashboardData();
      if (mounted) {
        setState(() {
          _data = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
<<<<<<< HEAD
      return const SizedBox(
        height: 400,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return SizedBox(
        height: 400,
        child: Center(child: Text('Error: $_error')),
      );
    }

    if (_data == null) return const SizedBox();

    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
=======
      return const Center(
>>>>>>> origin/mildpepper
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
<<<<<<< HEAD
            Text(
              'Namaste, ${_data!.userName}!',
              style: const TextStyle(
                color: Color(0xFF0EA5E9),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Solar Performance Overview',
              style: TextStyle(
                color: Color(0xFF0EA5E9),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),

            LayoutBuilder(
              builder: (context, constraints) {
                bool isLarge = constraints.maxWidth > 1200;
                final double leftFlex = isLarge ? 4 : 3;
                final double rightFlex = isLarge ? 8 : 7;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column (Narrow)
                    Expanded(
                      flex: leftFlex.toInt(),
                      child: Column(
                        children: [
                          EnergyProductionCard(data: _data!.energyProduction),
                          const SizedBox(height: 24),
                          TotalDevicesCard(devices: _data!.devices),
                        ],
                      ),
                    ),

                    const SizedBox(width: 24),

                    // Right Column (Wide)
                    Expanded(
                      flex: rightFlex.toInt(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: PlantsStatusCard(
                                      data: _data!.plantsStatus),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: NetZeroCard(data: _data!.netZero),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          EnergyGenerationChart(data: _data!.chartData),
                          const SizedBox(height: 24),
                          PlantsDetailsTable(plants: _data!.plants),
                        ],
                      ),
                    ),
                  ],
                );
              },
=======
            CircularProgressIndicator(color: Color(0xFF0EA5E9)),
            SizedBox(height: 16),
            Text(
              'Loading dashboard...',
              style: TextStyle(color: Color(0xFF64748B)),
>>>>>>> origin/mildpepper
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
              const SizedBox(height: 16),
              Text(
                'Failed to load dashboard',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0EA5E9),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final data = _data!;

    return RefreshIndicator(
      onRefresh: _loadData,
      color: const Color(0xFF0EA5E9),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Namaste, ${data.userName}!',
                style: const TextStyle(
                  color: Color(0xFF0EA5E9),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Solar Performance Overview',
                style: TextStyle(
                  color: Color(0xFF0EA5E9),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),

              LayoutBuilder(
                builder: (context, constraints) {
                  bool isLarge = constraints.maxWidth > 1200;

                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: isLarge ? 4 : 5,
                            child: Column(
                              children: [
                                EnergyProductionCard(data: data.energyProduction),
                                const SizedBox(height: 24),
                                TotalDevicesCard(devices: data.devices),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            flex: isLarge ? 8 : 7,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: PlantsStatusCard(
                                            data: data.plantsStatus)),
                                    const SizedBox(width: 24),
                                    Expanded(
                                        child: NetZeroCard(data: data.netZero)),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                EnergyGenerationChart(data: data.chartData),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      PlantsDetailsTable(plants: data.plants),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
