import 'package:flutter/material.dart';

class InvertersPage extends StatelessWidget {
  const InvertersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          const Text(
            'Dashboard / Inverters',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),

          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Inverters',
                    style: TextStyle(
                      color: Color(0xFF0EA5E9),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(25)',
                    style: TextStyle(
                      color: const Color(0xFF0EA5E9).withValues(alpha: 0.7),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  // Filter Button
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_alt_outlined,
                        color: Color(0xFF0EA5E9)),
                    label: const Text(
                      'Filter',
                      style: TextStyle(color: Color(0xFF0EA5E9)),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: const Color(0xFF0EA5E9).withValues(alpha: 0.3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Search Field
                  SizedBox(
                    width: 250,
                    child: TextField(
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
                            'Today Generation',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Total Generation',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Last Updated',
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
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: 8, // Mock data count
                      itemBuilder: (context, index) {
                        return _buildTableRow(
                          deviceName: 'Kutch Plant',
                          category: 'inverter',
                          manufac: 'Mindra',
                          todayGen: '36489 Kwh',
                          totalGen: '36489 Kwh',
                          lastUpdated: 'Jan 10, 8:00 AM',
                          // Different colors based on index for the mockup
                          statusColor: index == 0
                              ? Colors.orange
                              : index == 7
                                  ? Colors.red
                                  : Colors.green,
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

  Widget _buildTableRow({
    required String deviceName,
    required String category,
    required String manufac,
    required String todayGen,
    required String totalGen,
    required String lastUpdated,
    required Color statusColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  deviceName,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              category,
              style: const TextStyle(color: Color(0xFF475569)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              manufac,
              style: const TextStyle(color: Color(0xFF475569)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              todayGen,
              style: const TextStyle(color: Color.fromARGB(255, 21, 236, 78)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              totalGen,
              style: const TextStyle(color: Color.fromARGB(255, 21, 236, 78)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              lastUpdated,
              style: const TextStyle(color: Color(0xFF475569)),
            ),
          ),
        ],
      ),
    );
  }
}
