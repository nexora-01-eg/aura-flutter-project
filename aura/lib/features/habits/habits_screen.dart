import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_theme.dart';

class Habit {
  String icon, name;
  int streak;
  bool doneToday;
  List<int> heatmap; // 0-4 levels for 28 days
  Habit({required this.icon, required this.name, required this.streak,
         required this.doneToday, required this.heatmap});
}

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});
  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final List<Habit> _habits = [
    Habit(icon: '🧘', name: 'Morning Meditation', streak: 14, doneToday: true,
          heatmap: [0,0,1,1,2,2,3,3,4,4,3,2,3,4,4,3,2,3,4,4,3,2,1,2,3,4,4,4]),
    Habit(icon: '💪', name: 'Workout', streak: 14, doneToday: true,
          heatmap: [0,1,2,3,4,4,3,2,1,2,3,4,4,3,2,1,2,3,4,4,3,2,3,4,4,4,3,4]),
    Habit(icon: '📚', name: 'Read 30 Pages', streak: 9, doneToday: false,
          heatmap: [0,0,0,1,1,2,3,3,4,2,1,0,2,3,4,4,3,2,3,4,4,3,3,4,4,3,2,0]),
    Habit(icon: '🚿', name: 'Cold Shower', streak: 7, doneToday: true,
          heatmap: [0,0,0,0,0,0,0,1,2,3,4,4,3,2,2,3,4,4,3,3,4,4,3,4,4,4,3,4]),
    Habit(icon: '✍️', name: 'Journal Entry', streak: 14, doneToday: false,
          heatmap: [1,2,3,4,4,3,2,3,4,4,3,2,1,2,3,4,4,3,2,3,4,4,3,2,3,4,4,0]),
  ];

  void _toggle(Habit h) {
    HapticFeedback.lightImpact();
    setState(() {
      h.doneToday = !h.doneToday;
      if (h.doneToday) h.streak++;
      else h.streak = (h.streak - 1).clamp(0, 999);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.black,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('HABITS', style: AuraText.cinzel(size: 22, letterSpacing: 4)),
                    Text('TAP TO MARK COMPLETE', style: AuraText.label(size: 10)),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) {
                    if (i < _habits.length) {
                      return _HabitCard(habit: _habits[i], onToggle: () => _toggle(_habits[i]))
                          .animate(delay: Duration(milliseconds: i * 60))
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.15, end: 0);
                    }
                    // Heatmap section
                    if (i == _habits.length) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text('28-DAY CONSISTENCY MAP', style: AuraText.label()),
                          const SizedBox(height: 10),
                          _HeatmapWidget(habit: _habits[0]),
                          const SizedBox(height: 32),
                        ],
                      );
                    }
                    return null;
                  },
                  childCount: _habits.length + 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggle;
  const _HabitCard({required this.habit, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AuraColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AuraColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AuraColors.goldDim,
              border: Border.all(color: AuraColors.borderBright, width: 0.5),
            ),
            child: Center(child: Text(habit.icon, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(habit.name, style: AuraText.body(size: 13)),
                const SizedBox(height: 3),
                Text('🔥 ${habit.streak} day streak',
                    style: AuraText.body(size: 11, color: AuraColors.gold.withOpacity(0.8))),
              ],
            ),
          ),
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 34, height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: habit.doneToday ? AuraColors.gold : Colors.transparent,
                border: Border.all(
                  color: habit.doneToday ? AuraColors.gold : AuraColors.borderBright,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  habit.doneToday ? '✓' : '',
                  style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeatmapWidget extends StatelessWidget {
  final Habit habit;
  const _HeatmapWidget({required this.habit});

  Color _cellColor(int level) {
    switch (level) {
      case 1: return AuraColors.gold.withOpacity(0.15);
      case 2: return AuraColors.gold.withOpacity(0.35);
      case 3: return AuraColors.gold.withOpacity(0.6);
      case 4: return AuraColors.gold;
      default: return AuraColors.surface3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AuraColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AuraColors.border, width: 0.5),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemCount: habit.heatmap.length,
        itemBuilder: (_, i) => AnimatedContainer(
          duration: Duration(milliseconds: 300 + i * 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: _cellColor(habit.heatmap[i]),
            border: i == habit.heatmap.length - 1
                ? Border.all(color: AuraColors.gold, width: 1)
                : null,
          ),
        ),
      ),
    );
  }
}
