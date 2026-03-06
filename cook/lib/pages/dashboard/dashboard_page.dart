import 'package:flutter/material.dart';

import 'widgets/energy_production_card.dart';
import 'widgets/total_devices_card.dart';
import 'widgets/plants_status_card.dart';
import 'widgets/net_zero_card.dart';
import 'widgets/energy_revenue_chart.dart';
import 'widgets/plants_details_table.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Namaste, Dhruti!',
              style: TextStyle(
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
                            children: const [
                              EnergyProductionCard(),
                              SizedBox(height: 24),
                              TotalDevicesCard(),
                            ],
                          ),
                        ),

                        const SizedBox(width: 24),

                        Expanded(
                          flex: isLarge ? 8 : 7,
                          child: Column(
                            children: const [
                              Row(
                                children: [
                                  Expanded(child: PlantsStatusCard()),
                                  SizedBox(width: 24),
                                  Expanded(child: NetZeroCard()),
                                ],
                              ),
                              SizedBox(height: 24),
                              EnergyGenerationChart(),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const PlantsDetailsTable(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}