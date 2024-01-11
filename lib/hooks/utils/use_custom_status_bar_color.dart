import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useCustomStatusBarColor(
  Color color,
  bool isCurrentRoute, {
  bool noSetBGColor = false,
  bool? automaticSystemUiAdjustment,
}) {
  final context = useContext();
  final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
  resetStatusbar() => SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: backgroundColor, // status bar color
          statusBarIconBrightness: backgroundColor.computeLuminance() > 0.179
              ? Brightness.dark
              : Brightness.light,
        ),
      );

  final statusBarColor = SystemChrome.latestStyle?.statusBarColor;

  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (automaticSystemUiAdjustment != null) {
        WidgetsBinding.instance.renderView.automaticSystemUiAdjustment =
            automaticSystemUiAdjustment;
      }
      if (isCurrentRoute && statusBarColor != color) {
        final isLight = color.computeLuminance() > 0.179;
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor:
                noSetBGColor ? Colors.transparent : color, // status bar color
            statusBarIconBrightness:
                isLight ? Brightness.dark : Brightness.light,
          ),
        );
      } else if (!isCurrentRoute && statusBarColor == color) {
        resetStatusbar();
      }
    });
    return () {
      if (automaticSystemUiAdjustment != null) {
        WidgetsBinding.instance.renderView.automaticSystemUiAdjustment = false;
      }
    };
  }, [color, isCurrentRoute, statusBarColor]);

  useEffect(() {
    return resetStatusbar;
  }, []);
}
