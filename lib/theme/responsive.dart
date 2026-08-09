import 'package:flutter/widgets.dart';

/// Breakpoints for the web/desktop build. Mobile layouts are untouched below
/// [tablet]; wider viewports get side navigation and multi-column grids.
class Breakpoints {
  static const tablet = 700.0;
  static const desktop = 1024.0;
}

extension ResponsiveContext on BuildContext {
  double get _width => MediaQuery.sizeOf(this).width;
  bool get isTablet => _width >= Breakpoints.tablet && _width < Breakpoints.desktop;
  bool get isDesktop => _width >= Breakpoints.desktop;

  /// True from tablet width upward — the point at which side navigation
  /// replaces the bottom nav bar.
  bool get isWide => _width >= Breakpoints.tablet;
}

/// Centers content and caps its width once the viewport grows past phone
/// size, so forms and single-column screens don't stretch edge to edge on
/// tablet/desktop. Below [Breakpoints.tablet] this is a no-op passthrough.
class ResponsiveContent extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const ResponsiveContent({super.key, required this.child, this.maxWidth = 1100});

  @override
  Widget build(BuildContext context) {
    if (!context.isWide) return child;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
