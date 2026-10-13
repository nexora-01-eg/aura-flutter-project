import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../dashboard/dashboard_screen.dart';
import '../tasks/tasks_screen.dart';
import '../habits/habits_screen.dart';
import '../focus/focus_screen.dart';
import '../stats/stats_screen.dart';

class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({required this.child, super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _screens = const [
    DashboardScreen(),
    TasksScreen(),
    HabitsScreen(),
    FocusScreen(),
    StatsScreen(),
  ];

  final _routes = ['/home', '/tasks', '/habits', '/focus', '/stats'];

  final _items = [
    {'icon': '⬡', 'label': 'Home'},
    {'icon': '◈', 'label': 'Tasks'},
    {'icon': '◉', 'label': 'Habits'},
    {'icon': '◎', 'label': 'Focus'},
    {'icon': '◇', 'label': 'Stats'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.black,
      body: IndexedStack(
        index: _index,
        children: _screens,
      ),
      bottomNavigationBar: _AuraBottomNav(
        currentIndex: _index,
        items: _items,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _AuraBottomNav extends StatelessWidget {
  final int currentIndex;
  final List<Map<String, String>> items;
  final ValueChanged<int> onTap;

  const _AuraBottomNav({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AuraColors.deep,
        border: const Border(
          top: BorderSide(color: AuraColors.border, width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.8),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(
              items.length,
              (i) => Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: i == currentIndex ? 22 : 20,
                            color: i == currentIndex
                                ? AuraColors.gold
                                : AuraColors.textMuted,
                          ),
                          child: Text(items[i]['icon']!),
                        ),
                        const SizedBox(height: 3),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 9,
                            letterSpacing: 1.5,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            color: i == currentIndex
                                ? AuraColors.gold
                                : AuraColors.textMuted,
                          ),
                          child: Text(items[i]['label']!.toUpperCase()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
