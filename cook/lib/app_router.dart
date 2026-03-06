import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'layout/main_layout.dart';
import 'pages/auth/login_page.dart';
import 'pages/dashboard/dashboard_page.dart';
import 'pages/inverters/inverters_page.dart';
import 'pages/plants/plants_page.dart';
import 'pages/reports/reports_page.dart';
import 'pages/sensors/sensors_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/plants',
          builder: (context, state) => const PlantsPage(),
        ),
        GoRoute(
          path: '/reports',
          builder: (context, state) => const ReportsPage(),
        ),
        GoRoute(
          path: '/inverters',
          builder: (context, state) => const InvertersPage(),
        ),
        GoRoute(
          path: '/sensors',
          builder: (context, state) => const SensorsPage(),
        ),
      ],
    ),
  ],
);
