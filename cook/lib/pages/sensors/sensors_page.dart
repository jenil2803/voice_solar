import 'package:flutter/material.dart';
import '../../models/sensor_model.dart';

class SensorsPage extends StatefulWidget {
  const SensorsPage({super.key});

  @override
  State<SensorsPage> createState() => _SensorsPageState();
}

class _SensorsPageState extends State<SensorsPage> {
  String selectedTab = 'All';
  String searchQuery = '';

  String _formatDate(DateTime date) {
    String pad(int n) => n.toString().padLeft(2, '0');
    final month = pad(date.month);
    final day = pad(date.day);
    final year = date.year;
    
    int hour = date.hour;
    final period = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;
    
    final minute = pad(date.minute);
    final second = pad(date.second);
    
    return '$month/$day/$year, $hour:$minute:$second $period';
  }

  List<SensorModel> get filteredSensors {
    var list = selectedTab.toLowerCase() == 'all' 
        ? mockSensorsDatabase 
        : mockSensorsDatabase.where((s) => s.category.toLowerCase() == selectedTab.toLowerCase()).toList();
    if (searchQuery.isNotEmpty) {
      list = list.where((s) => s.deviceName.toLowerCase().contains(searchQuery.toLowerCase()) || 
                               s.manufacturer.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final sensors = filteredSensors;
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          const Text(
            'Dashboard / Sensors',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),

          // Header Row with Title and Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Sensors',
                        style: TextStyle(
                          color: Color(0xFF0EA5E9),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${sensors.length})',
                        style: TextStyle(
                          color: const Color(0xFF0EA5E9).withValues(alpha: 0.7),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Custom Tabs
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF0EA5E9).withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTab('All', isFirst: true),
                        _buildTab('WMS'),
                        _buildTab('MFM'),
                        _buildTab('Temperature', isLast: true),
                      ],
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  

                  // Search Field
                  SizedBox(
                    width: 250,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search Devices',
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                        prefixIcon: const Icon(Icons.search,
                            color: Color(0xFF94A3B8)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.2),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.2),
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
          ),
          const SizedBox(height: 24),

          // Main Table Content
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF0EA5E9).withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  // Table Header
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9).withValues(alpha: 0.5),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: const Color(0xFF0EA5E9).withValues(alpha: 0.3),
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
                            'Created On',
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
                    child: ListView.builder(
                      itemCount: sensors.length,
                      itemBuilder: (context, index) {
                        final sensor = sensors[index];
                        return Container(
                          color: index.isOdd 
                              ? const Color(0xFFF8FAFC) 
                              : Colors.white,
                          child: _buildTableRow(sensor),
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

  Widget _buildTab(String title, {bool isFirst = false, bool isLast = false}) {
    final isSelected = selectedTab == title;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(isFirst ? 8 : 0),
            right: Radius.circular(isLast ? 8 : 0),
          ),
          border: Border(
            right: !isLast 
                ? BorderSide(color: const Color(0xFF0EA5E9).withValues(alpha: 0.3)) 
                : BorderSide.none,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFF0EA5E9) : const Color(0xFF64748B),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTableRow(SensorModel sensor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              sensor.deviceName,
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: sensor.categoryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  sensor.category.toLowerCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              sensor.manufacturer,
              style: const TextStyle(color: Color(0xFF475569)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _formatDate(sensor.createdOn),
              style: const TextStyle(color: Color(0xFF475569)),
            ),
          ),
        ],
      ),
    );
  }
}
