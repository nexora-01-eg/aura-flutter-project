import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  int _displayScore = 0;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // Animate score count
    Future.delayed(400.ms, () {
      _animateScore(87);
    });
  }

  void _animateScore(int target) {
    const steps = 40;
    final perStep = target / steps;
    for (int i = 0; i <= steps; i++) {
      Future.delayed(Duration(milliseconds: i * 35), () {
        if (mounted) setState(() => _displayScore = min(target, (perStep * i).round()));
      });
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String get _dateStr {
    const days = ['SUN','MON','TUE','WED','THU','FRI','SAT'];
    const months = ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'];
    final n = DateTime.now();
    return '${days[n.weekday % 7]} · ${months[n.month-1]} ${n.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Top App Bar
          SliverAppBar(
            pinned: true,
            backgroundColor: AuraColors.deep,
            expandedHeight: 0,
            toolbarHeight: 64,
            flexibleSpace: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('AURA', style: AuraText.cinzel(size: 20, letterSpacing: 5, color: AuraColors.gold)),
                  Text(_dateStr, style: AuraText.label()),
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AuraColors.borderBright, width: 1),
                      gradient: const LinearGradient(
                        colors: [AuraColors.surface, AuraColors.surface2],
                      ),
                    ),
                    child: Center(child: Text('AR', style: AuraText.label(size: 11, color: AuraColors.gold, letterSpacing: 0.5))),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // Greeting
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_greeting.toUpperCase(), style: AuraText.label()),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        text: 'Welcome back, ',
                        style: AuraText.cinzel(size: 22),
                        children: [
                          TextSpan(text: 'Alex.', style: AuraText.cinzel(size: 22, color: AuraColors.gold)),
                        ],
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 20),

                // ── AURA SCORE CARD ──
                _buildScoreCard(),

                const SizedBox(height: 14),

                // ── STATS GRID ──
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.5,
                  children: [
                    _StatCard(icon: '🔥', value: '14', label: 'Day Streak', sub: '↑ Personal best'),
                    _StatCard(icon: '⏱', value: '3h 42m', label: 'Focus Time', sub: 'Goal: 4h'),
                    _StatCard(icon: '✓', value: '5/8', label: 'Tasks Done', sub: 'Today'),
                    _XpRingCard(percent: 0.72),
                  ],
                ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

                const SizedBox(height: 16),

                // ── WEEKLY GRAPH ──
                _buildWeeklyGraph(),

                const SizedBox(height: 14),

                // ── QUOTE ──
                _buildQuote(),

                const SizedBox(height: 14),

                // ── STREAK BADGE ──
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFC0513A).withOpacity(0.15),
                        AuraColors.gold.withOpacity(0.08),
                      ],
                    ),
                    border: Border.all(color: const Color(0xFFC0513A).withOpacity(0.35), width: 0.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text('14-day streak — don\'t break the chain!',
                          style: AuraText.body(size: 12, color: const Color(0xFFE87A5A))),
                    ],
                  ),
                ).animate().fadeIn(delay: 600.ms),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard() {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (_, __) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF111111),
              Color.lerp(const Color(0xFF111111), const Color(0xFF1A1500), _pulseCtrl.value * 0.6)!,
            ],
          ),
          border: Border.all(color: AuraColors.borderBright, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: AuraColors.gold.withOpacity(0.06 + _pulseCtrl.value * 0.04),
              blurRadius: 40,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DAILY AURA SCORE', style: AuraText.label(color: AuraColors.gold.withOpacity(0.7))),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [AuraColors.gold, AuraColors.gold3],
                  ).createShader(b),
                  child: Text('$_displayScore',
                    style: const TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 54,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6, left: 4),
                  child: Text('/100', style: AuraText.body(color: AuraColors.textMuted, size: 18)),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AuraColors.goldDim,
                    border: Border.all(color: AuraColors.borderBright, width: 0.5),
                  ),
                  child: Text('⚡ ELITE', style: AuraText.label(color: AuraColors.gold, size: 11)),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 0.87),
                duration: const Duration(milliseconds: 1400),
                curve: Curves.easeOutCubic,
                builder: (_, v, __) => LinearProgressIndicator(
                  value: v,
                  minHeight: 3,
                  backgroundColor: Colors.white.withOpacity(0.06),
                  valueColor: const AlwaysStoppedAnimation(AuraColors.gold),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Level 12 — Discipline Warrior', style: AuraText.label(size: 10)),
                Text('1,240 XP', style: AuraText.label(size: 10)),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildWeeklyGraph() {
    const heights = [52.0, 78, 45, 88, 72, 61, 87];
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AuraColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AuraColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('WEEKLY MOMENTUM', style: AuraText.label()),
          const SizedBox(height: 14),
          SizedBox(
            height: 80,
            child: BarChart(
              BarChartData(
                maxY: 100,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) => Text(
                        days[v.toInt()],
                        style: AuraText.label(size: 9, color: v == 6 ? AuraColors.gold : AuraColors.textMuted),
                      ),
                    ),
                  ),
                ),
                barGroups: List.generate(7, (i) => BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: heights[i],
                      width: 20,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      gradient: i == 6
                          ? const LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [AuraColors.gold, AuraColors.gold3],
                            )
                          : LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AuraColors.gold.withOpacity(0.15),
                                AuraColors.gold.withOpacity(0.05),
                              ],
                            ),
                    ),
                  ],
                )),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 350.ms);
  }

  Widget _buildQuote() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AuraColors.surface,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
        border: const Border(
          left: BorderSide(color: AuraColors.gold, width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"We are what we repeatedly do. Excellence, then, is not an act, but a habit."',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: AuraColors.text,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          Text('— ARISTOTLE', style: AuraText.label(color: AuraColors.gold.withOpacity(0.6))),
        ],
      ),
    ).animate().fadeIn(delay: 450.ms);
  }
}

class _StatCard extends StatelessWidget {
  final String icon, value, label, sub;
  const _StatCard({required this.icon, required this.value, required this.label, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AuraColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AuraColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Text(value, style: AuraText.cinzel(size: 20, weight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label.toUpperCase(), style: AuraText.label(size: 9)),
          Text(sub, style: AuraText.body(size: 10, color: AuraColors.gold.withOpacity(0.7))),
        ],
      ),
    );
  }
}

class _XpRingCard extends StatelessWidget {
  final double percent;
  const _XpRingCard({required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AuraColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AuraColors.border, width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 52, height: 52,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: percent),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (_, v, __) => Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: v,
                    strokeWidth: 4,
                    backgroundColor: Colors.white.withOpacity(0.06),
                    valueColor: const AlwaysStoppedAnimation(AuraColors.gold),
                    strokeCap: StrokeCap.round,
                  ),
                  Text('${(v * 100).round()}%', style: AuraText.cinzel(size: 10, color: AuraColors.gold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text('XP TO NEXT', style: AuraText.label(size: 9)),
        ],
      ),
    );
  }
}
