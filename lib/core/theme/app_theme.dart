import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        background: AppColors.background,
        surface: AppColors.surface,
        card: AppColors.card,
        text: AppColors.textPrimary,
        secondary: AppColors.textSecondary,
        stroke: AppColors.stroke,
        chip: AppColors.chip,
        overlay: SystemUiOverlayStyle.light,
      );

  static ThemeData light() => _build(
        brightness: Brightness.light,
        background: AppColors.lightBackground,
        surface: AppColors.lightSurface,
        card: AppColors.lightCard,
        text: AppColors.lightText,
        secondary: AppColors.lightTextSecondary,
        stroke: AppColors.lightStroke,
        chip: AppColors.lightChip,
        overlay: SystemUiOverlayStyle.dark,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color card,
    required Color text,
    required Color secondary,
    required Color stroke,
    required Color chip,
    required SystemUiOverlayStyle overlay,
  }) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: brightness == Brightness.dark ? AppColors.accent : AppColors.lightText,
      onPrimary: brightness == Brightness.dark ? AppColors.background : Colors.white,
      secondary: AppColors.accentMuted,
      onSecondary: AppColors.background,
      error: AppColors.danger,
      onError: Colors.white,
      surface: surface,
      onSurface: text,
    );
    final textTheme = AppTypography.textTheme(text);
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: overlay,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      ),
      dividerTheme: DividerThemeData(color: stroke, thickness: 1),
      chipTheme: ChipThemeData(
        backgroundColor: chip,
        side: BorderSide.none,
        labelStyle: textTheme.labelMedium?.copyWith(color: text),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
          textStyle: textTheme.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: text),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: brightness == Brightness.dark ? AppColors.cardRaised : AppColors.lightText,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: brightness == Brightness.dark ? AppColors.textPrimary : Colors.white,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return secondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary.withValues(alpha: 0.35);
          return stroke;
        }),
      ),
    );
  }
}
