// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// A test GoRouter that can be used in tests.
class TestGoRouter extends StatelessWidget {
  final Widget child;
  final GoRouter goRouter;

  const TestGoRouter({super.key, required this.child, required this.goRouter});

  @override
  Widget build(BuildContext context) {
    return InheritedGoRouter(
      goRouter: goRouter,
      child: child,
    );
  }
}
