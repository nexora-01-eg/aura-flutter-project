import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 3200));
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('onboarding_done') ?? false;
    if (!mounted) return;
    context.go(seen ? '/home' : '/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ambient glow
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AuraColors.gold.withOpacity(0.08),
                    blurRadius: 120,
                    spreadRadius: 60,
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 1200.ms),

            // AURA Logo
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AuraColors.gold, AuraColors.gold2, AuraColors.gold3],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                'AURA',
                style: TextStyle(
                  fontFamily: 'Cinzel',
                  fontSize: 58,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 16,
                ),
              ),
            )
                .animate()
                .fadeIn(delay: 500.ms, duration: 1000.ms)
                .scale(
                  begin: const Offset(0.85, 0.85),
                  end: const Offset(1, 1),
                  delay: 500.ms,
                  duration: 1200.ms,
                  curve: Curves.easeOutExpo,
                ),

            const SizedBox(height: 14),

            // Tagline
            Text(
              'Discipline Creates Freedom.',
              style: TextStyle(
                fontFamily: 'Cormorant Garamond',
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: AuraColors.gold.withOpacity(0.5),
                letterSpacing: 3,
              ),
            )
                .animate()
                .fadeIn(delay: 1400.ms, duration: 800.ms)
                .slideY(begin: 0.3, end: 0, delay: 1400.ms, duration: 800.ms),

            const SizedBox(height: 60),

            // Pulse line
            Container(
              width: 1,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AuraColors.gold,
                    Colors.transparent,
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .fadeIn(delay: 2200.ms, duration: 600.ms)
                .scaleY(begin: 0.2, end: 1, delay: 2200.ms, duration: 600.ms),
          ],
        ),
      ),
    );
  }
}
