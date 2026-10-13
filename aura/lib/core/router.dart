import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../features/splash/splash_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/dashboard/main_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (_, __) => const OnboardingScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home',    builder: (_, __) => const _Placeholder('Home')),
        GoRoute(path: '/tasks',   builder: (_, __) => const _Placeholder('Tasks')),
        GoRoute(path: '/habits',  builder: (_, __) => const _Placeholder('Habits')),
        GoRoute(path: '/focus',   builder: (_, __) => const _Placeholder('Focus')),
        GoRoute(path: '/stats',   builder: (_, __) => const _Placeholder('Stats')),
      ],
    ),
  ],
);

class _Placeholder extends StatelessWidget {
  final String name;
  const _Placeholder(this.name);
  @override
  Widget build(BuildContext context) => Center(child: Text(name));
}
