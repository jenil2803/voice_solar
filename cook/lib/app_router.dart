import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'layout/main_layout.dart';
import 'pages/dashboard/dashboard_page.dart';
import 'pages/inverters/inverters_page.dart';
import 'pages/inverters/inverter_detail_page.dart';
import 'pages/plants/plants_page.dart';
import 'pages/plants/plant_detail_page.dart';
import 'pages/reports/reports_page.dart';
import 'pages/sensors/sensors_page.dart';
import 'pages/sensors/sensor_detail_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        // Dashboard
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardPage(),
        ),

        // Plants — list + detail
        GoRoute(
          path: '/plants',
          builder: (context, state) => const PlantsPage(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) =>
                  PlantDetailPage(id: state.pathParameters['id']!),
            ),
          ],
        ),

        // Reports
        GoRoute(
          path: '/reports',
          builder: (context, state) => const ReportsPage(),
        ),

        // Inverters — list + detail
        GoRoute(
          path: '/inverters',
          builder: (context, state) => const InvertersPage(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) =>
                  InverterDetailPage(id: state.pathParameters['id']!),
            ),
          ],
        ),

        // Sensors — list + detail
        GoRoute(
          path: '/sensors',
          builder: (context, state) => const SensorsPage(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) =>
                  SensorDetailPage(id: state.pathParameters['id']!),
            ),
          ],
        ),
      ],
    ),
  ],
);
