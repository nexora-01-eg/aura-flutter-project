import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../core/theme/app_theme.dart';

class Task {
  String id, name, time, category;
  int priority; // 0=low 1=med 2=high
  bool done;
  int xp;
  Task({required this.id, required this.name, required this.time,
        required this.category, required this.priority, required this.done, required this.xp});
}

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final List<Task> _tasks = [
    Task(id: '1', name: 'Deep Work Session — Product Strategy', time: '09:00 · 2h block', category: 'Work', priority: 2, done: false, xp: 30),
    Task(id: '2', name: 'Review Q2 Analytics Report', time: '11:00 · 45min', category: 'Work', priority: 2, done: false, xp: 20),
    Task(id: '3', name: 'Morning Meditation — 20 mins', time: '07:00', category: 'Personal', priority: 1, done: true, xp: 15),
    Task(id: '4', name: 'Cold Shower — Discipline Training', time: '06:30', category: 'Health', priority: 1, done: true, xp: 25),
    Task(id: '5', name: 'Read 30 Pages — Atomic Habits', time: '21:00', category: 'Learning', priority: 0, done: false, xp: 20),
    Task(id: '6', name: 'Workout — Upper Body Strength', time: '06:00 · 75min', category: 'Health', priority: 0, done: true, xp: 10),
    Task(id: '7', name: 'Plan tomorrow\'s priorities', time: '22:00', category: 'Personal', priority: 1, done: false, xp: 10),
  ];

  String? _xpTaskId;
  int _xpAmount = 0;

  int get _doneCount => _tasks.where((t) => t.done).length;

  void _toggleTask(Task task) {
    HapticFeedback.lightImpact();
    setState(() {
      task.done = !task.done;
      if (task.done) {
        _xpTaskId = task.id;
        _xpAmount = task.xp;
        Future.delayed(900.ms, () {
          if (mounted) setState(() => _xpTaskId = null);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pending = _tasks.where((t) => !t.done).toList();
    final done = _tasks.where((t) => t.done).toList();

    return Scaffold(
      backgroundColor: AuraColors.black,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TASKS', style: AuraText.cinzel(size: 22, letterSpacing: 4)),
                        Text('$_doneCount of ${_tasks.length} completed',
                            style: AuraText.label(size: 11, letterSpacing: 1)),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => _showAddTask(context),
                      child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AuraColors.goldDim,
                          border: Border.all(color: AuraColors.borderBright, width: 0.5),
                        ),
                        child: const Center(
                          child: Text('+', style: TextStyle(fontSize: 20, color: AuraColors.gold, height: 1)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  if (pending.isNotEmpty) ...[
                    Text('PRIORITY', style: AuraText.label()),
                    const SizedBox(height: 8),
                    AnimationLimiter(
                      child: Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 400),
                          childAnimationBuilder: (w) => SlideAnimation(
                            verticalOffset: 20,
                            child: FadeInAnimation(child: w),
                          ),
                          children: pending.map((t) => _TaskItem(
                            task: t,
                            showXp: _xpTaskId == t.id,
                            xpAmount: _xpAmount,
                            onToggle: () => _toggleTask(t),
                          )).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (done.isNotEmpty) ...[
                    Text('COMPLETED', style: AuraText.label()),
                    const SizedBox(height: 8),
                    Column(children: done.map((t) => _TaskItem(
                      task: t,
                      showXp: false,
                      xpAmount: 0,
                      onToggle: () => _toggleTask(t),
                    )).toList()),
                  ],
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AuraColors.surface2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('NEW TASK', style: AuraText.cinzel(size: 16, letterSpacing: 3)),
            const SizedBox(height: 16),
            TextField(
              autofocus: true,
              style: AuraText.body(size: 15),
              cursorColor: AuraColors.gold,
              decoration: InputDecoration(
                hintText: 'What must be done...',
                hintStyle: AuraText.body(color: AuraColors.textMuted),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AuraColors.border),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AuraColors.gold),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AuraColors.goldDim,
                  foregroundColor: AuraColors.gold,
                  side: const BorderSide(color: AuraColors.borderBright, width: 0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text('ADD TASK', style: AuraText.label(color: AuraColors.gold, size: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskItem extends StatelessWidget {
  final Task task;
  final bool showXp;
  final int xpAmount;
  final VoidCallback onToggle;

  const _TaskItem({required this.task, required this.showXp, required this.xpAmount, required this.onToggle});

  Color get _priorityColor {
    switch (task.priority) {
      case 2: return const Color(0xFFC0513A);
      case 1: return AuraColors.gold;
      default: return const Color(0xFF3A6C4A);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onToggle,
          child: AnimatedOpacity(
            opacity: task.done ? 0.45 : 1,
            duration: const Duration(milliseconds: 300),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AuraColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AuraColors.border, width: 0.5),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 22, height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: task.done ? AuraColors.gold : Colors.transparent,
                      border: Border.all(
                        color: task.done ? AuraColors.gold : AuraColors.borderBright,
                        width: 1.5,
                      ),
                    ),
                    child: task.done
                        ? const Icon(Icons.check, size: 12, color: Colors.black)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.name,
                          style: AuraText.body(
                            size: 13,
                            color: task.done ? AuraColors.textMuted : AuraColors.text,
                          ).copyWith(
                            decoration: task.done ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text('${task.time} · ${task.category}',
                            style: AuraText.label(size: 10, letterSpacing: 0.5)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 6, height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _priorityColor,
                      boxShadow: [BoxShadow(color: _priorityColor.withOpacity(0.5), blurRadius: 6)],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // XP pop
        if (showXp)
          Positioned(
            right: 24, top: 0,
            child: Text('+$xpAmount XP',
              style: AuraText.body(color: AuraColors.gold, size: 11).copyWith(fontWeight: FontWeight.w600, letterSpacing: 1),
            ).animate()
              .fadeIn(duration: 200.ms)
              .slideY(begin: 0, end: -1.5, duration: 800.ms, curve: Curves.easeOut)
              .fadeOut(delay: 500.ms, duration: 300.ms),
          ),
      ],
    );
  }
}
