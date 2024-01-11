import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// ignore: constant_identifier_names
const Breakpoints = (
  xs: 480.0,
  sm: 640.0,
  md: 820.0,
  lg: 1024.0,
  xl: 1280.0,
);

extension SliverBreakpoints on SliverConstraints {
  bool get isXs => crossAxisExtent <= Breakpoints.xs;
  bool get isSm =>
      crossAxisExtent > Breakpoints.xs && crossAxisExtent <= Breakpoints.sm;
  bool get isMd =>
      crossAxisExtent > Breakpoints.sm && crossAxisExtent <= Breakpoints.md;
  bool get isLg =>
      crossAxisExtent > Breakpoints.md && crossAxisExtent <= Breakpoints.lg;
  bool get isXl =>
      crossAxisExtent > Breakpoints.lg && crossAxisExtent <= Breakpoints.xl;
  bool get is2Xl => crossAxisExtent > Breakpoints.xl;

  bool get smAndUp => isSm || isMd || isLg || isXl || is2Xl;
  bool get mdAndUp => isMd || isLg || isXl || is2Xl;
  bool get lgAndUp => isLg || isXl || is2Xl;
  bool get xlAndUp => isXl || is2Xl;

  bool get smAndDown => isXs || isSm;
  bool get mdAndDown => isXs || isSm || isMd;
  bool get lgAndDown => isXs || isSm || isMd || isLg;
  bool get xlAndDown => isXs || isSm || isMd || isLg || isXl;
}

extension ContainerBreakpoints on BoxConstraints {
  bool get isXs => biggest.width <= Breakpoints.xs;
  bool get isSm =>
      biggest.width > Breakpoints.xs && biggest.width <= Breakpoints.sm;
  bool get isMd =>
      biggest.width > Breakpoints.sm && biggest.width <= Breakpoints.md;
  bool get isLg =>
      biggest.width > Breakpoints.md && biggest.width <= Breakpoints.lg;
  bool get isXl =>
      biggest.width > Breakpoints.lg && biggest.width <= Breakpoints.xl;
  bool get is2Xl => biggest.width > Breakpoints.xl;

  bool get smAndUp => isSm || isMd || isLg || isXl || is2Xl;
  bool get mdAndUp => isMd || isLg || isXl || is2Xl;
  bool get lgAndUp => isLg || isXl || is2Xl;
  bool get xlAndUp => isXl || is2Xl;

  bool get smAndDown => isXs || isSm;
  bool get mdAndDown => isXs || isSm || isMd;
  bool get lgAndDown => isXs || isSm || isMd || isLg;
  bool get xlAndDown => isXs || isSm || isMd || isLg || isXl;
}

extension ScreenBreakpoints on MediaQueryData {
  bool get isXs => size.width <= Breakpoints.xs;
  bool get isSm => size.width > Breakpoints.xs && size.width <= Breakpoints.sm;
  bool get isMd => size.width > Breakpoints.sm && size.width <= Breakpoints.md;
  bool get isLg => size.width > Breakpoints.md && size.width <= Breakpoints.lg;
  bool get isXl => size.width > Breakpoints.lg && size.width <= Breakpoints.xl;
  bool get is2Xl => size.width > Breakpoints.xl;

  bool get smAndUp => isSm || isMd || isLg || isXl || is2Xl;
  bool get mdAndUp => isMd || isLg || isXl || is2Xl;
  bool get lgAndUp => isLg || isXl || is2Xl;
  bool get xlAndUp => isXl || is2Xl;

  bool get smAndDown => isXs || isSm;
  bool get mdAndDown => isXs || isSm || isMd;
  bool get lgAndDown => isXs || isSm || isMd || isLg;
  bool get xlAndDown => isXs || isSm || isMd || isLg || isXl;
}
