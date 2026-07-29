import 'package:flutter/material.dart';

import 'layout_breakpoints.dart';

class AdaptiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const AdaptiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (LayoutBreakpoints.isDesktop(width)) {
          return desktop ?? tablet ?? mobile;
        }

        if (LayoutBreakpoints.isTablet(width)) {
          return tablet ?? mobile;
        }

        return mobile;
      },
    );
  }
}
