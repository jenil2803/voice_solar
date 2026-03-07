import 'package:flutter/material.dart';

class SensorModel {
  final String deviceName;
  final String category;
  final String manufacturer;
  final DateTime createdOn;

  SensorModel({
    required this.deviceName,
    required this.category,
    required this.manufacturer,
    required this.createdOn,
  });

  Color get categoryColor {
    switch (category.toLowerCase()) {
      case 'wms':
        return const Color(0xFFEF4444); // Red
      case 'temperature':
        return const Color(0xFFF59E0B); // Orange
      case 'mfm':
        return const Color(0xFF3B82F6); // Blue
      default:
        return const Color(0xFF94A3B8); // Gray
    }
  }
}

// Mock Database
final List<SensorModel> mockSensorsDatabase = [
  SensorModel(
    deviceName: 'CANT_RADIATION_1',
    category: 'wms',
    manufacturer: 'Weather Monitoring',
    createdOn: DateTime(2025, 12, 24, 16, 49, 16),
  ),
  SensorModel(
    deviceName: 'CANT_TEMP_1',
    category: 'temperature',
    manufacturer: 'Weather Monitoring',
    createdOn: DateTime(2025, 12, 24, 16, 56, 34),
  ),
  SensorModel(
    deviceName: 'CANT_MFM_1',
    category: 'mfm',
    manufacturer: 'Schneider Electric',
    createdOn: DateTime(2025, 12, 26, 10, 50, 56),
  ),
  SensorModel(
    deviceName: 'MOULD_MFM_2',
    category: 'mfm',
    manufacturer: 'Schneider Electric',
    createdOn: DateTime(2025, 12, 26, 10, 54, 35),
  ),
  SensorModel(
    deviceName: 'SPS_MFM_3',
    category: 'mfm',
    manufacturer: 'Schneider Electric',
    createdOn: DateTime(2025, 12, 26, 10, 40, 55),
  ),
  // Additional Mock Entries
  SensorModel(
    deviceName: 'MAIN_WMS_1',
    category: 'wms',
    manufacturer: 'Weather Monitoring',
    createdOn: DateTime(2025, 12, 27, 8, 15, 0),
  ),
  SensorModel(
    deviceName: 'ZONE2_TEMP_1',
    category: 'temperature',
    manufacturer: 'Sensirion',
    createdOn: DateTime(2025, 12, 27, 9, 30, 22),
  ),
  SensorModel(
    deviceName: 'INVERTER_MFM_1',
    category: 'mfm',
    manufacturer: 'Schneider Electric',
    createdOn: DateTime(2025, 12, 27, 11, 45, 15),
  ),
  SensorModel(
    deviceName: 'BACKUP_TEMP_2',
    category: 'temperature',
    manufacturer: 'Sensirion',
    createdOn: DateTime(2025, 12, 28, 14, 20, 10),
  ),
  SensorModel(
    deviceName: 'ROOF_RADIATION_2',
    category: 'wms',
    manufacturer: 'Weather Monitoring',
    createdOn: DateTime(2025, 12, 28, 15, 10, 05),
  ),
];
