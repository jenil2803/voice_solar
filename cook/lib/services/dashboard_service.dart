import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dashboard_models.dart';

/// Service layer for fetching dashboard data.
class DashboardService {
  /// Fetches all dashboard data.
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
  Future<EnergyChartData> getChartData({
    required ChartPeriodType period,
    DateTime? from,
    DateTime? to,
  }) async {
    return getDashboardData().then((d) => d.chartData);
  }
}
