import 'package:flutter/material.dart';

class PlantsDetailsTable extends StatelessWidget {
  const PlantsDetailsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF60A5FA).withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Plants Details',
                  style: TextStyle(
                    color: Color(0xFF0EA5E9),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.tune, color: Color(0xFF0EA5E9)),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search Plants',
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFF60A5FA)),
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    columnSpacing: 24,
                    headingRowColor:
                        WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                    columns: const [
                      DataColumn(
                          label: Text('Plant Name',
                              style: TextStyle(color: Color(0xFF64748B)))),
                      DataColumn(
                          label: Text('Today',
                              style: TextStyle(color: Color(0xFF64748B)))),
                      DataColumn(
                          label: Text('Total',
                              style: TextStyle(color: Color(0xFF64748B)))),
                      DataColumn(
                          label: Text('Capacity',
                              style: TextStyle(color: Color(0xFF64748B)))),
                      DataColumn(
                          label: Text('Last Updated',
                              style: TextStyle(color: Color(0xFF64748B)))),
                    ],
                    rows: List.generate(
                      6,
                      (index) {
                        Color dotColor;

                        if (index == 0) {
                          dotColor = const Color(0xFFF59E0B);
                        } else if (index >= 4) {
                          dotColor = const Color(0xFFEF4444);
                        } else {
                          dotColor = const Color(0xFF22C55E);
                        }

                        return DataRow(
                          cells: [
                            DataCell(
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: dotColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      'Kutch Plant',
                                      style: TextStyle(color: Color(0xFF334155)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const DataCell(Text('36489 Kwh',
                                style: TextStyle(color: Color(0xFF334155)))),
                            const DataCell(Text('36489 Kwh',
                                style: TextStyle(color: Color(0xFF334155)))),
                            const DataCell(Text('36489 Kwh',
                                style: TextStyle(color: Color(0xFF334155)))),
                            const DataCell(Text('Jan 10, 8:00 AM',
                                style: TextStyle(color: Color(0xFF334155)))),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}