import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_theme.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});
  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen>
    with SingleTickerProviderStateMixin {
  static const _totalSeconds = 25 * 60;
  int _seconds = _totalSeconds;
  bool _running = false;
  Timer? _timer;
  int _sessions = 3;
  late AnimationController _breathCtrl;

  final _ambients = ['🌧 Rain', '☕ Café', '🌌 Space', '🌊 Ocean', '🌬 Wind', '🕯 Dark'];
  final Set<int> _activeAmbients = {0};

  @override
  void initState() {
    super.initState();
    _breathCtrl = AnimationController(
      vsync: this, duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breathCtrl.dispose();
    super.dispose();
  }

  void _toggleTimer() {
    HapticFeedback.mediumImpact();
    setState(() {
      _running = !_running;
      if (_running) {
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          setState(() {
            _seconds--;
            if (_seconds <= 0) {
              _sessions++;
              _seconds = _totalSeconds;
              _running = false;
              _timer?.cancel();
              HapticFeedback.heavyImpact();
            }
          });
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void _reset() {
    HapticFeedback.lightImpact();
    _timer?.cancel();
    setState(() { _seconds = _totalSeconds; _running = false; });
  }

  void _skip() {
    HapticFeedback.lightImpact();
    _timer?.cancel();
    setState(() { _sessions++; _seconds = _totalSeconds; _running = false; });
  }

  String get _timeStr {
    final m = _seconds ~/ 60;
    final s = _seconds % 60;
    return '${m.toString().padLeft(2,'0')}:${s.toString().padLeft(2,'0')}';
  }

  double get _progress => _seconds / _totalSeconds;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const ringSize = 220.0;
    const r = ringSize / 2 - 10;
    const circ = 2 * pi * r;

    return Scaffold(
      backgroundColor: AuraColors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 24),

                // Header
                Text('DEEP FOCUS', style: AuraText.cinzel(size: 18, letterSpacing: 5, color: AuraColors.gold))
                    .animate().fadeIn(duration: 500.ms),

                const SizedBox(height: 6),
                Text('Deep Work Session — Product Strategy',
                    textAlign: TextAlign.center,
                    style: AuraText.body(size: 13, color: AuraColors.textDim))
                    .animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 40),

                // ── TIMER RING ──
                SizedBox(
                  width: ringSize, height: ringSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Breathing glow
                      AnimatedBuilder(
                        animation: _breathCtrl,
                        builder: (_, __) => Container(
                          width: ringSize + 20 * _breathCtrl.value,
                          height: ringSize + 20 * _breathCtrl.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(
                              color: AuraColors.gold.withOpacity(_running ? 0.08 + 0.06 * _breathCtrl.value : 0.04),
                              blurRadius: 60,
                              spreadRadius: 10,
                            )],
                          ),
                        ),
                      ),

                      // SVG-style ring
                      CustomPaint(
                        size: const Size(ringSize, ringSize),
                        painter: _RingPainter(
                          progress: _progress,
                          circumference: circ,
                          radius: r,
                        ),
                      ),

                      // Center content
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_timeStr,
                            style: const TextStyle(
                              fontFamily: 'Cinzel',
                              fontSize: 38,
                              fontWeight: FontWeight.w700,
                              color: AuraColors.text,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(_running ? 'FOCUS' : 'PAUSED',
                            style: AuraText.label(color: AuraColors.gold.withOpacity(0.7))),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 32),

                // ── CONTROLS ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ControlBtn(icon: '↺', onTap: _reset),
                    const SizedBox(width: 14),
                    GestureDetector(
                      onTap: _toggleTimer,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 68, height: 68,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AuraColors.goldDim,
                          border: Border.all(color: AuraColors.gold, width: 1),
                          boxShadow: _running ? [
                            BoxShadow(color: AuraColors.gold.withOpacity(0.2), blurRadius: 20)
                          ] : [],
                        ),
                        child: Center(
                          child: Text(_running ? '⏸' : '▶', style: const TextStyle(fontSize: 24)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    _ControlBtn(icon: '⏭', onTap: _skip),
                  ],
                ).animate().fadeIn(delay: 400.ms),

                const SizedBox(height: 32),

                // ── SESSION STATS ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StatPill(value: '$_sessions', label: 'Sessions'),
                    const SizedBox(width: 1),
                    Container(width: 0.5, height: 36, color: AuraColors.border),
                    const SizedBox(width: 1),
                    _StatPill(value: '1h 15m', label: 'Focus Today'),
                    const SizedBox(width: 1),
                    Container(width: 0.5, height: 36, color: AuraColors.border),
                    const SizedBox(width: 1),
                    _StatPill(value: '5', label: 'Breaks Left'),
                  ],
                ),

                const SizedBox(height: 32),

                // ── AMBIENT ──
                Text('AMBIENT ATMOSPHERE', style: AuraText.label()),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: List.generate(_ambients.length, (i) {
                    final on = _activeAmbients.contains(i);
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          if (on) _activeAmbients.remove(i);
                          else _activeAmbients.add(i);
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: on ? AuraColors.goldDim : Colors.transparent,
                          border: Border.all(
                            color: on ? AuraColors.gold : AuraColors.border,
                            width: 0.5,
                          ),
                        ),
                        child: Text(_ambients[i],
                          style: AuraText.body(size: 12,
                              color: on ? AuraColors.gold : AuraColors.textMuted)),
                      ),
                    );
                  }),
                ).animate().fadeIn(delay: 500.ms),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ControlBtn extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  const _ControlBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52, height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AuraColors.borderBright, width: 0.5),
          color: AuraColors.surface,
        ),
        child: Center(child: Text(icon, style: const TextStyle(fontSize: 20, color: AuraColors.gold))),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String value, label;
  const _StatPill({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: AuraText.cinzel(size: 18, color: AuraColors.gold)),
          const SizedBox(height: 3),
          Text(label.toUpperCase(), style: AuraText.label(size: 8, letterSpacing: 1),
               textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress, circumference, radius;
  _RingPainter({required this.progress, required this.circumference, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);

    // Track
    canvas.drawCircle(c, radius, Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3);

    // Progress arc
    final sweep = 2 * pi * progress;
    final gradient = SweepGradient(
      startAngle: -pi / 2,
      endAngle: -pi / 2 + sweep,
      colors: const [AuraColors.gold, AuraColors.gold3],
    );
    final rect = Rect.fromCircle(center: c, radius: radius);
    canvas.drawArc(
      rect, -pi / 2, sweep, false,
      Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}
