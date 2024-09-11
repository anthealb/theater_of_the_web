import 'package:flutter/material.dart';

class Theming {
  static final colorSchemeLight =
      ColorScheme.fromSwatch(primarySwatch: Colors.indigo, backgroundColor: Colors.indigo[50]); //.copyWith(onErrorContainer: Colors.black),

  static final inputDecorationTheme = InputDecorationTheme(
    errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorSchemeLight.error)),
    focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorSchemeLight.primary)),
    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
    hoverColor: colorSchemeLight.onSurface,
    floatingLabelStyle: WidgetStateTextStyle.resolveWith((Set<WidgetState> states) {
      final TextStyle textStyle = const TextTheme().bodyLarge ?? const TextStyle();
      if (states.contains(WidgetState.disabled)) {
        return textStyle.copyWith(color: colorSchemeLight.onSurface.withOpacity(0.38));
      }
      if (states.contains(WidgetState.error)) {
        if (states.contains(WidgetState.hovered)) {
          return textStyle.copyWith(color: colorSchemeLight.primary);
        }
        if (states.contains(WidgetState.focused)) {
          return textStyle.copyWith(color: colorSchemeLight.primary);
        }
        return textStyle.copyWith(color: colorSchemeLight.error);
      }
      if (states.contains(WidgetState.hovered)) {
        return textStyle.copyWith(color: colorSchemeLight.secondary);
      }
      if (states.contains(WidgetState.focused)) {
        return textStyle.copyWith(color: colorSchemeLight.primary);
      }
      return textStyle.copyWith(color: colorSchemeLight.onSurface);
    }),
    labelStyle: WidgetStateTextStyle.resolveWith((Set<WidgetState> states) {
      final TextStyle textStyle = const TextTheme().bodyLarge ?? const TextStyle();
      if (states.contains(WidgetState.disabled)) {
        return textStyle.copyWith(color: colorSchemeLight.onSurface.withOpacity(0.38));
      }
      if (states.contains(WidgetState.error)) {
        if (states.contains(WidgetState.hovered)) {
          return textStyle.copyWith(color: colorSchemeLight.primary);
        }
        if (states.contains(WidgetState.focused)) {
          return textStyle.copyWith(color: colorSchemeLight.primary);
        }
        return textStyle.copyWith(color: colorSchemeLight.error);
      }
      if (states.contains(WidgetState.hovered)) {
        return textStyle.copyWith(color: colorSchemeLight.secondary);
      }
      if (states.contains(WidgetState.focused)) {
        return textStyle.copyWith(color: colorSchemeLight.primary);
      }
      return textStyle.copyWith(color: colorSchemeLight.onSurface);
    }),
  );

  static final switchTheme = SwitchThemeData(
    trackOutlineColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return Colors.transparent;
      if (states.contains(WidgetState.disabled)) return colorSchemeLight.onSurface.withOpacity(0.12);
      return colorSchemeLight.onSurface;
    }),
  );

  static final themeData = ThemeData(
    colorScheme: colorSchemeLight,
    inputDecorationTheme: inputDecorationTheme,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    switchTheme: switchTheme,
    iconTheme: const IconThemeData(size: 18),
  );

  static Widget errorShakeBuilder(BuildContext context, double value, Widget child) {
    const double shakeDelta = 4.0;
    final translateX = (value <= 0.25)
        ? -value * shakeDelta
        : (value < 0.75)
            ? (value - 0.5) * shakeDelta
            : (1.0 - value) * 4.0 * shakeDelta;
    return Transform(
      transform: Matrix4.translationValues(translateX, 0.0, 0.0),
      child: child,
    );
  }
}
