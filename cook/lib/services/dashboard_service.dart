import '../models/dashboard_models.dart';

/// Service layer for fetching dashboard data.
///
/// =============================================================================
/// MONGODB / BACKEND INTEGRATION GUIDE
/// =============================================================================
///
/// This service is the bridge between the UI and your data source.
/// To connect to MongoDB:
///
/// 1. ADD HTTP CLIENT: Add `http` or `dio` package to pubspec.yaml for API calls.
///
/// 2. REPLACE MOCK DATA: Replace the getDashboardData method body with an async API call:
///    Future getDashboardData() async {
///      final response = await http.get(Uri.parse('$baseUrl/api/dashboard'));
///      if (response.statusCode == 200) {
///        return DashboardData.fromJson(jsonDecode(response.body));
///      }
///      throw Exception('Failed to load dashboard');
///    }
///
/// 3. SUGGESTED API ENDPOINTS (for your backend team):
///    - GET /api/dashboard          -> Full dashboard (or split into below)
///    - GET /api/dashboard/energy   -> EnergyProductionData
///    - GET /api/dashboard/devices  -> List of DeviceCount
///    - GET /api/dashboard/plants   -> PlantsStatusData + List of PlantDetail
///    - GET /api/dashboard/netzero  -> NetZeroData
///    - GET /api/dashboard/chart?period=monthly&from=...&to=... -> EnergyChartData
///
/// 4. MONGODB COLLECTIONS (suggested schema):
///    - users: { name, email, ... }
///    - plants: { name, status, todayKwh, totalKwh, capacityKwh, lastUpdated, ... }
///    - devices: { type, count, plantId?, ... }
///    - energy_readings: { date, kwh, plantId?, ... }
///    - sustainability: { co2Reduced, coalSaved, treesPlanted, ... }
///
/// 5. ERROR HANDLING: Consider returning optional/cached data on partial failures.
///
class DashboardService {
  /// Fetches all dashboard data.
  ///
  /// TODO: Replace with MongoDB/API call. Example:
  /// ```dart
  /// final db = MongoClient(connectionString).db('solar_db');
  /// final energy = await db.collection('energy').findOne();
  /// return DashboardData(...);
  /// ```
  Future<DashboardData> getDashboardData() async {
    // Simulate network delay - remove when using real API
    await Future.delayed(const Duration(milliseconds: 300));

    // MOCK DATA - Replace this entire block with your API/MongoDB fetch.
    // Example with API: return DashboardData.fromJson(
    //   jsonDecode((await http.get(Uri.parse('$baseUrl/api/dashboard'))).body)
    // );
    return DashboardData(
      userName: 'Dhruti',
      energyProduction: const EnergyProductionData(
        todayKwh: '20 kWh',
        percentage: 50.75,
        totalProduction: '42.8 kWh',
        totalCapacity: '42.8 kWh',
      ),
      devices: const [
        DeviceCount(type: 'MFM', count: 5, flex: 5),
        DeviceCount(type: 'WFM', count: 1, flex: 1),
        DeviceCount(type: 'SLMS', count: 2, flex: 2),
        DeviceCount(type: 'Inverters', count: 4, flex: 4),
      ],
      plantsStatus: const PlantsStatusData(
        totalPlants: 45,
        active: 30,
        alert: 10,
        partiallyActive: 10,
        expired: 10,
      ),
      netZero: const NetZeroData(
        co2Reduced: '1.03k',
        coalSaved: '1.4 T',
        treesPlanted: '155K',
      ),
      chartData: EnergyChartData(
        periodLabel: 'September 2026',
        periodType: ChartPeriodType.yearly,
        maxY: 40,
        bars: List.generate(
          22,
          (i) => ChartBarData(
            x: i + 1,
            y: (i == 19) ? 38 : (20 + (i % 5) * 4).toDouble(),
          ),
        ),
      ),
      plants: [
        PlantDetail(
          name: 'Kutch Plant',
          status: PlantStatus.partiallyActive,
          todayKwh: '36489 Kwh',
          totalKwh: '36489 Kwh',
          capacityKwh: '36489 Kwh',
          lastUpdated: 'Jan 10, 8:00 AM',
        ),
        ...List.generate(
          5,
          (i) => PlantDetail(
            name: 'Plant ${i + 2}',
            status: i >= 4 ? PlantStatus.expired : PlantStatus.active,
            todayKwh: '36489 Kwh',
            totalKwh: '36489 Kwh',
            capacityKwh: '36489 Kwh',
            lastUpdated: 'Jan 10, 8:00 AM',
          ),
        ),
      ],
    );
  }

  /// Optional: Fetch only chart data when user changes period.
  /// MongoDB: Query energy_readings aggregated by selected period.
  Future<EnergyChartData> getChartData({
    required ChartPeriodType period,
    DateTime? from,
    DateTime? to,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // TODO: Replace with API call - GET /api/chart?period=monthly&from=...&to=...
    return getDashboardData().then((d) => d.chartData);
  }
}
