import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dashboard_models.dart';

/// Service layer for fetching dashboard data.
class DashboardService {
  /// Fetches all dashboard data.
  Future<DashboardData> getDashboardData({ChartPeriodType period = ChartPeriodType.monthly}) async {
    try {
      final String baseUrl = 'http://127.0.0.1:8000';
      final response = await http.get(Uri.parse('$baseUrl/dashboard?period=${period.name}'));
      
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

  /// Fetches all plants
  Future<List<PlantDetail>> getPlants() async {
    try {
      final String baseUrl = 'http://127.0.0.1:8000';
      final response = await http.get(Uri.parse('$baseUrl/plants/'));
      
      if (response.statusCode == 200) {
        final List<dynamic> decoded = jsonDecode(response.body);
        return decoded.map((e) => PlantDetail.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load plants: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to backend: $e');
    }
  }

  /// Fetches all inverters
  Future<List<InverterDetail>> getInverters() async {
    try {
      final String baseUrl = 'http://127.0.0.1:8000';
      final response = await http.get(Uri.parse('$baseUrl/inverters/'));
      
      if (response.statusCode == 200) {
        final List<dynamic> decoded = jsonDecode(response.body);
        return decoded.map((e) => InverterDetail.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load inverters: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to backend: $e');
    }
  }
}
