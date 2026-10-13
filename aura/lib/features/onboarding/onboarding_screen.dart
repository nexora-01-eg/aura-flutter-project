import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _ctrl = PageController();
  int _page = 0;

  final _slides = [
    _Slide(
      quote: 'Discipline\nCreates Freedom.',
      sub: 'The life you want is built one decision at a time.',
      icon: '⚡',
    ),
    _Slide(
      quote: 'Small Actions\nBuild Greatness.',
      sub: 'Every completed task is a vote for who you are becoming.',
      icon: '🎯',
    ),
    _Slide(
      quote: 'Consistency\nBeats Motivation.',
      sub: 'Show up every day. Your future self will thank you.',
      icon: '🔥',
    ),
  ];

  void _next() async {
    if (_page < 2) {
      _ctrl.nextPage(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_done', true);
      if (!mounted) return;
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.black,
      body: Stack(
        children: [
          // Background glow
          Positioned(
            top: -100, left: -100,
            child: Container(
              width: 400, height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AuraColors.gold.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Pages
          PageView.builder(
            controller: _ctrl,
            onPageChanged: (i) => setState(() => _page = i),
            itemCount: 3,
            itemBuilder: (context, i) => _SlidePage(slide: _slides[i]),
          ),

          // Bottom controls
          Positioned(
            bottom: 60, left: 32, right: 32,
            child: Column(
              children: [
                // Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _page ? 24 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: i == _page
                          ? AuraColors.gold
                          : AuraColors.gold.withOpacity(0.2),
                    ),
                  )),
                ),
                const SizedBox(height: 32),

                // CTA Button
                GestureDetector(
                  onTap: _next,
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const LinearGradient(
                        colors: [AuraColors.gold, AuraColors.gold3],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AuraColors.gold.withOpacity(0.3),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _page < 2 ? 'CONTINUE' : 'ENTER AURA',
                        style: const TextStyle(
                          fontFamily: 'Cinzel',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AuraColors.black,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Slide {
  final String quote, sub, icon;
  const _Slide({required this.quote, required this.sub, required this.icon});
}

class _SlidePage extends StatelessWidget {
  final _Slide slide;
  const _SlidePage({required this.slide, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(slide.icon, style: const TextStyle(fontSize: 48))
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.5, 0.5), duration: 600.ms, curve: Curves.easeOutBack),

          const SizedBox(height: 32),

          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [AuraColors.text, AuraColors.gold2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(b),
            child: Text(
              slide.quote,
              style: const TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.2,
                letterSpacing: 1,
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 700.ms)
              .slideY(begin: 0.2, end: 0, delay: 200.ms, duration: 700.ms),

          const SizedBox(height: 20),

          Text(
            slide.sub,
            style: TextStyle(
              fontFamily: 'Cormorant Garamond',
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: AuraColors.textDim,
              height: 1.6,
            ),
          )
              .animate()
              .fadeIn(delay: 500.ms, duration: 700.ms),

          const SizedBox(height: 40),

          Container(
            width: 48,
            height: 1,
            color: AuraColors.gold.withOpacity(0.4),
          )
              .animate()
              .fadeIn(delay: 700.ms, duration: 500.ms)
              .slideX(begin: -1, end: 0, delay: 700.ms, duration: 500.ms),
        ],
      ),
    );
  }
}
