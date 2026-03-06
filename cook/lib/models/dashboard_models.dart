// Dashboard data models for the Solar app.
//
// BACKEND/MongoDB INTEGRATION:
// These models mirror the structure expected from your API/database.
// Use the fromJson factories when parsing API responses. Your MongoDB
// documents / API JSON should match these field names.

/// Energy production metrics for the gauge card.
class EnergyProductionData {
  final String todayKwh;
  final double percentage;
  final String totalProduction;
  final String totalCapacity;

  const EnergyProductionData({
    required this.todayKwh,
    required this.percentage,
    required this.totalProduction,
    required this.totalCapacity,
  });

  /// Parse from API/MongoDB response. Expect: { todayKwh, percentage, totalProduction, totalCapacity }
  factory EnergyProductionData.fromJson(Map<String, dynamic> json) =>
      EnergyProductionData(
        todayKwh: json['todayKwh'] as String? ?? '0 kWh',
        percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
        totalProduction: json['totalProduction'] as String? ?? '0 kWh',
        totalCapacity: json['totalCapacity'] as String? ?? '0 kWh',
      );
}

/// Device type and count for the stacked bar chart.
/// MongoDB: Consider a collection like `devices` with fields: type, count.
class DeviceCount {
  final String type;
  final int count;
  final int flex; // For bar width proportion

  const DeviceCount({
    required this.type,
    required this.count,
    this.flex = 1,
  });

  /// Parse from API. Expect: { type, count } - flex defaults to count if omitted
  factory DeviceCount.fromJson(Map<String, dynamic> json) {
    final count = json['count'] as int? ?? 0;
    return DeviceCount(
      type: json['type'] as String? ?? '',
      count: count,
      flex: json['flex'] as int? ?? count,
    );
  }
}

/// Plants status breakdown.
/// MongoDB: Aggregate from `plants` collection by status field.
class PlantsStatusData {
  final int totalPlants;
  final int active;
  final int alert;
  final int partiallyActive;
  final int expired;

  const PlantsStatusData({
    required this.totalPlants,
    required this.active,
    required this.alert,
    required this.partiallyActive,
    required this.expired,
  });

  /// Parse from API. Expect: { totalPlants, active, alert, partiallyActive, expired }
  factory PlantsStatusData.fromJson(Map<String, dynamic> json) =>
      PlantsStatusData(
        totalPlants: json['totalPlants'] as int? ?? 0,
        active: json['active'] as int? ?? 0,
        alert: json['alert'] as int? ?? 0,
        partiallyActive: json['partiallyActive'] as int? ?? 0,
        expired: json['expired'] as int? ?? 0,
      );
}

/// Net zero / sustainability metrics.
/// MongoDB: Could come from a `sustainability` or `environmental_impact` collection.
class NetZeroData {
  final String co2Reduced;
  final String coalSaved;
  final String treesPlanted;

  const NetZeroData({
    required this.co2Reduced,
    required this.coalSaved,
    required this.treesPlanted,
  });

  /// Parse from API. Expect: { co2Reduced, coalSaved, treesPlanted }
  factory NetZeroData.fromJson(Map<String, dynamic> json) => NetZeroData(
        co2Reduced: json['co2Reduced'] as String? ?? '0',
        coalSaved: json['coalSaved'] as String? ?? '0',
        treesPlanted: json['treesPlanted'] as String? ?? '0',
      );
}

/// Single bar data point for the energy/revenue chart.
/// MongoDB: Aggregate energy readings by day/month from `readings` or `energy_logs`.
class ChartBarData {
  final int x;
  final double y;

  const ChartBarData({required this.x, required this.y});

  /// Parse from API. Expect: { x, y }
  factory ChartBarData.fromJson(Map<String, dynamic> json) => ChartBarData(
        x: json['x'] as int? ?? 0,
        y: (json['y'] as num?)?.toDouble() ?? 0,
      );
}

/// Energy chart configuration and data.
/// MongoDB: Query by date range, group by period (daily/monthly).
class EnergyChartData {
  final String periodLabel;
  final ChartPeriodType periodType;
  final List<ChartBarData> bars;
  final double maxY;

  const EnergyChartData({
    required this.periodLabel,
    required this.periodType,
    required this.bars,
    this.maxY = 40,
  });

  /// Parse from API. Expect: { periodLabel, periodType, bars: [{x,y}...], maxY? }
  factory EnergyChartData.fromJson(Map<String, dynamic> json) {
    final barsList = json['bars'] as List<dynamic>? ?? [];
    return EnergyChartData(
      periodLabel: json['periodLabel'] as String? ?? '',
      periodType: ChartPeriodType.values.firstWhere(
        (e) => e.name == json['periodType'],
        orElse: () => ChartPeriodType.monthly,
      ),
      bars: barsList
          .map((e) => ChartBarData.fromJson(e as Map<String, dynamic>))
          .toList(),
      maxY: (json['maxY'] as num?)?.toDouble() ?? 40,
    );
  }
}

enum ChartPeriodType { monthly, yearly, lifetime }

/// Plant status for the status indicator dot.
enum PlantStatus { active, alert, partiallyActive, expired }

/// Single plant row for the plants details table.
/// MongoDB: Map directly from `plants` collection documents.
class PlantDetail {
  final String name;
  final PlantStatus status;
  final String todayKwh;
  final String totalKwh;
  final String capacityKwh;
  final String lastUpdated;

  const PlantDetail({
    required this.name,
    required this.status,
    required this.todayKwh,
    required this.totalKwh,
    required this.capacityKwh,
    required this.lastUpdated,
  });

  /// Parse from API. Expect: { name, status, todayKwh, totalKwh, capacityKwh, lastUpdated }
  /// status: 'active' | 'alert' | 'partiallyActive' | 'expired'
  factory PlantDetail.fromJson(Map<String, dynamic> json) {
    final statusStr = json['status'] as String? ?? 'active';
    return PlantDetail(
      name: json['name'] as String? ?? '',
      status: PlantStatus.values.firstWhere(
        (e) => e.name == statusStr,
        orElse: () => PlantStatus.active,
      ),
      todayKwh: json['todayKwh'] as String? ?? '0',
      totalKwh: json['totalKwh'] as String? ?? '0',
      capacityKwh: json['capacityKwh'] as String? ?? '0',
      lastUpdated: json['lastUpdated'] as String? ?? '',
    );
  }
}

/// Full dashboard data - all widgets consume from this.
/// MongoDB: Your API can return this as a single aggregated response,
/// or you can fetch each section separately for better performance.
class DashboardData {
  final String userName;
  final EnergyProductionData energyProduction;
  final List<DeviceCount> devices;
  final PlantsStatusData plantsStatus;
  final NetZeroData netZero;
  final EnergyChartData chartData;
  final List<PlantDetail> plants;

  const DashboardData({
    required this.userName,
    required this.energyProduction,
    required this.devices,
    required this.plantsStatus,
    required this.netZero,
    required this.chartData,
    required this.plants,
  });

  /// Parse full dashboard from API. Expect nested JSON matching model structure.
  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final devicesList = json['devices'] as List<dynamic>? ?? [];
    final plantsList = json['plants'] as List<dynamic>? ?? [];
    return DashboardData(
      userName: json['userName'] as String? ?? 'User',
      energyProduction: EnergyProductionData.fromJson(
        (json['energyProduction'] as Map<String, dynamic>?) ?? {},
      ),
      devices: devicesList
          .map((e) => DeviceCount.fromJson(e as Map<String, dynamic>))
          .toList(),
      plantsStatus: PlantsStatusData.fromJson(
        (json['plantsStatus'] as Map<String, dynamic>?) ?? {},
      ),
      netZero: NetZeroData.fromJson(
        (json['netZero'] as Map<String, dynamic>?) ?? {},
      ),
      chartData: EnergyChartData.fromJson(
        (json['chartData'] as Map<String, dynamic>?) ?? {},
      ),
      plants: plantsList
          .map((e) => PlantDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
