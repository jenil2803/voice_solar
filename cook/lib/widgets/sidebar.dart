import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../services/auth_service.dart';

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

          _NavItem(
            icon: LucideIcons.factory,
            isActive: location.startsWith('/plants'),
            onTap: () => context.go('/plants'),
          ),

          const SizedBox(height: 20),

          _NavItem(
            assetIcon: 'assets/icons/inverter_icon.png',
            isActive: location.startsWith('/inverters'),
            onTap: () => context.go('/inverters'),
          ),

          const SizedBox(height: 20),


          _NavItem(
            assetIcon: 'assets/icons/sensors_icon.png',
            isActive: location.startsWith('/sensors'),
            onTap: () => context.go('/sensors'),
          ),

          const SizedBox(height: 20),

          

          const SizedBox(height: 20),

          _NavItem(
            assetIcon: 'assets/icons/logout_outlined_icon.png',
            isActive: false,
            onTap: () {
              authService.logout();
              context.go('/login');
            },
          ),

          const Spacer(),


        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
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
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: widget.isActive
                    ? Colors.white
                    : (_isHovered
                        ? Colors.grey.withValues(alpha: 0.1)
                        : Colors.transparent),
                borderRadius: BorderRadius.circular(12),
                boxShadow: widget.isActive
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              child: widget.assetIcon != null
                  ? Image.asset(
                      widget.assetIcon!,
                      color: widget.isActive || _isHovered
                          ? const Color(0xFF0EA5E9)
                          : const Color(0xFF64748B),
                      width: 24,
                      height: 24,
                    )
                  : Icon(
                      widget.icon,
                      color: widget.isActive || _isHovered
                          ? const Color(0xFF0EA5E9)
                          : const Color(0xFF64748B),
                      size: 24,
                    ),
            ),
            if (widget.hasBadge)
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
      ),
    );
  }
}