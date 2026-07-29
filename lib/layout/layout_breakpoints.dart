class LayoutBreakpoints {
  const LayoutBreakpoints._();

  static const double mobile = 700.0;

  static const double desktop = 1000.0;

  static bool isMobile(double width) {
    return width < mobile;
  }

  static bool isTablet(double width) {
    return width >= mobile &&
        width < desktop;
  }

  static bool isDesktop(double width) {
    return width >= desktop;
  }
}
