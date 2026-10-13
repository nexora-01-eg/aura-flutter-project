import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/theme/app_theme.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

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
                padding: const EdgeInsets.fromLTRB(20,20,20,0),
                child: Text('ANALYTICS', style: AuraText.cinzel(size: 22, letterSpacing: 4)),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([

                  // Top stats
                  GridView.count(
                    crossAxisCount: 2, shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10, crossAxisSpacing: 10,
                    childAspectRatio: 1.4,
                    children: [
                      _BigStat('87', 'Aura Score', '↑ 12 from last week'),
                      _BigStat('1,240', 'Total XP', 'Top 8% this week'),
                      _BigStat('18.5h', 'Focus Hours', 'This month'),
                      _BigStat('94%', 'Habit Rate', '30-day avg'),
                    ],
                  ).animate().fadeIn(duration: 400.ms),

                  const SizedBox(height: 20),

                  // Radar chart
                  Text('DISCIPLINE PROFILE', style: AuraText.label()),
                  const SizedBox(height: 10),
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: AuraColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AuraColors.border, width: 0.5),
                    ),
                    child: const _RadarChart(),
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 20),

                  // Monthly bar chart
                  Text('MONTHLY FOCUS HOURS', style: AuraText.label()),
                  const SizedBox(height: 10),
                  Container(
                    height: 140,
                    padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                    decoration: BoxDecoration(
                      color: AuraColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AuraColors.border, width: 0.5),
                    ),
                    child: BarChart(
                      BarChartData(
                        maxY: 8,
                        gridData: FlGridData(
                          show: true,
                          horizontalInterval: 4,
                          getDrawingHorizontalLine: (_) => FlLine(
                            color: Colors.white.withOpacity(0.04), strokeWidth: 0.5),
                        ),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (v, _) {
                                const labels = ['W1','W2','W3','W4'];
                                final i = v.toInt();
                                if (i < labels.length) return Text(labels[i], style: AuraText.label(size: 9));
                                return const SizedBox();
                              },
                            ),
                          ),
                        ),
                        barGroups: [
                          for (final e in [(0,5.2),(1,6.8),(2,4.5),(3,7.3)])
                            BarChartGroupData(x: e.$1, barRods: [BarChartRodData(
                              toY: e.$2, width: 28,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter, end: Alignment.topCenter,
                                colors: [AuraColors.gold.withOpacity(0.2), AuraColors.gold],
                              ),
                            )]),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms),

                  const SizedBox(height: 20),

                  // Achievements
                  Text('ACHIEVEMENTS', style: AuraText.label()),
                  const SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 3, shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10, crossAxisSpacing: 10,
                    childAspectRatio: 0.9,
                    children: [
                      _Badge('⚡', 'Focus Master', true),
                      _Badge('🔥', '14 Day Streak', true),
                      _Badge('⚔️', 'Discipline Warrior', true),
                      _Badge('🌙', 'No Miss Week', false),
                      _Badge('💎', '30 Day Flawless', false),
                      _Badge('🏆', 'Aura Elite', false),
                    ],
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BigStat extends StatelessWidget {
  final String value, label, sub;
  const _BigStat(this.value, this.label, this.sub);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AuraColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AuraColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AuraText.cinzel(size: 26, color: AuraColors.gold2)),
          const SizedBox(height: 4),
          Text(label.toUpperCase(), style: AuraText.label(size: 9)),
          const SizedBox(height: 2),
          Text(sub, style: AuraText.body(size: 10, color: AuraColors.textDim)),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String icon, name;
  final bool earned;
  const _Badge(this.icon, this.name, this.earned);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AuraColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: earned ? AuraColors.borderBright : AuraColors.border,
          width: 0.5,
        ),
        gradient: earned ? const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF111111), Color(0xFF1A1500)],
        ) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon,
            style: TextStyle(fontSize: 24, color: earned ? null : const Color(0xFF333333))),
          const SizedBox(height: 6),
          Text(name,
            textAlign: TextAlign.center,
            style: AuraText.label(
              size: 8,
              color: earned ? AuraColors.gold : AuraColors.textMuted,
              letterSpacing: 1,
            )),
        ],
      ),
    );
  }
}

class _RadarChart extends StatelessWidget {
  const _RadarChart();

  @override
  Widget build(BuildContext context) {
    return RadarChart(
      RadarChartData(
        dataSets: [
          RadarDataSet(
            fillColor: AuraColors.gold.withOpacity(0.12),
            borderColor: AuraColors.gold,
            borderWidth: 1.5,
            entryRadius: 3,
            dataEntries: const [
              RadarEntry(value: 90),
              RadarEntry(value: 85),
              RadarEntry(value: 75),
              RadarEntry(value: 88),
              RadarEntry(value: 70),
            ],
          ),
        ],
        radarShape: RadarShape.polygon,
        tickCount: 3,
        ticksTextStyle: const TextStyle(fontSize: 0, color: Colors.transparent),
        radarBorderData: const BorderSide(color: Colors.transparent),
        gridBorderData: BorderSide(color: Colors.white.withOpacity(0.05), width: 0.5),
        tickBorderData: BorderSide(color: Colors.white.withOpacity(0.05), width: 0.5),
        getTitle: (i, _) {
          const labels = ['FOCUS', 'HABITS', 'TASKS', 'STREAK', 'ENERGY'];
          return RadarChartTitle(
            text: labels[i],
            positionPercentageOffset: 0.1,
          );
        },
        titleTextStyle: AuraText.label(size: 9),
      ),
    );
  }
}
