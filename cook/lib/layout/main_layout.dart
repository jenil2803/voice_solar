import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/ai_agent_dialog.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  void _showAIAgent(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AIAgentDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
          const Sidebar(),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: child,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAIAgent(context),
        backgroundColor: Colors.blue,
        elevation: 4,
        child: const Icon(LucideIcons.sparkles, color: Colors.white),
      ),
    );
  }
}