import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    // Current route to highlight active icon
    final String location = GoRouterState.of(context).uri.toString();

    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(
            color: Colors.grey.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),

          // Logo placeholder
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Center(
              child: Text(
                'D',
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 48),

          // Navigation Icons
          _NavItem(
            icon: LucideIcons.layoutGrid,
            isActive: location == '/' || location.startsWith('/dashboard'),
            onTap: () => context.go('/'),
          ),

          const SizedBox(height: 20),

          _NavItem(
            icon: LucideIcons.factory,
            isActive: location.startsWith('/plants'),
            onTap: () => context.go('/plants'),
          ),

          const SizedBox(height: 20),

          _NavItem(
<<<<<<< HEAD
            icon: LucideIcons.bookOpen,
            isActive: location.startsWith('/reports'),
            onTap: () => context.go('/reports'),
=======
            assetIcon: 'assets/icons/inverter_icon.png',
            isActive: location.startsWith('/inverters'),
            onTap: () => context.go('/inverters'),
>>>>>>> origin/mildpepper
          ),

          const SizedBox(height: 20),

          _NavItem(
<<<<<<< HEAD
            icon: LucideIcons.refreshCcw,
=======
            assetIcon: 'assets/icons/sync_icon.png',
>>>>>>> origin/mildpepper
            isActive: location.startsWith('/sync'),
            onTap: () {},
          ),

          const SizedBox(height: 20),

          _NavItem(
<<<<<<< HEAD
            icon: LucideIcons.wifi,
            isActive: location.startsWith('/network'),
            onTap: () {},
=======
            assetIcon: 'assets/icons/sensors_icon.png',
            isActive: location.startsWith('/sensors'),
            onTap: () => context.go('/sensors'),
>>>>>>> origin/mildpepper
          ),

          const SizedBox(height: 20),

          _NavItem(
<<<<<<< HEAD
            icon: LucideIcons.logOut,
=======
            assetIcon: 'assets/icons/logout_outlined_icon.png',
>>>>>>> origin/mildpepper
            isActive: false,
            onTap: () {},
          ),

          const Spacer(),

          // Bottom Icons
          _NavItem(
            icon: LucideIcons.bell,
            isActive: false,
            onTap: () {},
            hasBadge: true,
          ),

          const SizedBox(height: 20),

          _NavItem(
            icon: LucideIcons.userPlus,
            isActive: false,
            onTap: () {},
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData? icon;
  final String? assetIcon;
  final bool isActive;
  final VoidCallback onTap;
  final bool hasBadge;

  const _NavItem({
    this.icon,
    this.assetIcon,
    required this.isActive,
    required this.onTap,
    this.hasBadge = false,
  }) : assert(icon != null || assetIcon != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : null,
            ),
            child: assetIcon != null
                ? Image.asset(
                    assetIcon!,
                    color: isActive
                        ? const Color(0xFF0EA5E9)
                        : const Color(0xFF64748B),
                    width: 24,
                    height: 24,
                  )
                : Icon(
                    icon,
                    color: isActive
                        ? const Color(0xFF0EA5E9)
                        : const Color(0xFF64748B),
                    size: 24,
                  ),
          ),
          if (hasBadge)
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF0EA5E9),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}