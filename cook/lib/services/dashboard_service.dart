import 'dart:convert';
import 'package:http/http.dart' as http;
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
    try {
      // 10.0.2.2 is the android emulator loopback alias to the host machine
      // Adjust this URL to your environment as needed (e.g. your local IP or production URL)
      final String baseUrl = 'http://127.0.0.1:8000';
      final response = await http.get(Uri.parse('$baseUrl/dashboard'));
      
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return DashboardData.fromJson(decoded);
      } else {
        throw Exception('Failed to load dashboard: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to backend: $e');
    }
  }

  /// Optional: Fetch only chart data when user changes period.
  /// MongoDB: Query energy_readings aggregated by selected period.
  Future<EnergyChartData> getChartData({
    required ChartPeriodType period,
    DateTime? from,
    DateTime? to,
  }) async {
    // Optionally implemented with specific backend calls.
    // Right now, reusing the full dashboard fetch which incorporates chart mock.
    return getDashboardData().then((d) => d.chartData);
  }
}
