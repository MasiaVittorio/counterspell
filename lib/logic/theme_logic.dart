import 'package:counter_spell/models/theme/saved_theme.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

extension ThemeLogicFromContext on BuildContext {
  ThemeLogic get themeLogic => ThemeLogic.of(this);
}

class ThemeLogic extends ThemeLogicBase {
  static ThemeLogic of(BuildContext context) => context.provide<ThemeLogic>();

  @override
  CustomScheme get defaultCustomScheme => CustomScheme(
    dynamicSchemeVariant: DynamicSchemeVariant.tonalSpot,
    contrastLevel: 0,
    seedColor: Colors.grey,
  );

  PersistentReactive<bool> floatingPanel = PersistentReactive(
    false,
    key: 'floatingPanel',
  );
  PersistentReactive<bool> floatingAlerts = PersistentReactive(
    false,
    key: 'floatingAlerts',
  );

  PersistentReactive<List<SavedTheme>> savedThemes = PersistentReactive(
    [],
    key: 'savedThemes',
    toJsonEncodable: (value) => [for (final th in value) th.toMap()],
    fromJsonDecoded: (jsonDecoded) => [
      for (final m in jsonDecoded as List) SavedTheme.fromMap(m),
    ],
  );

  @override
  void dispose() {
    savedThemes.dispose();
    floatingPanel.dispose();
    floatingAlerts.dispose();
    super.dispose();
  }

  ThemeLogic({
    super.initialThemeMode = ThemeMode.dark,
    super.initialUseDynamic = true,
    super.initialCustomScheme,
  });

  @override
  ThemeData applyAppCustomizations(ThemeData theme) {
    const layout = Layout.defaultLayout;
    final scaffoldBackgroundColor = theme.brightness.isLight
        ? const Color(0xfff8f8f8)
        : theme.scaffoldBackgroundColor;

    return theme.copyWith(
      highlightColor: Colors.transparent,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      iconTheme: theme.iconTheme.copyWith(color: theme.colorScheme.onSurface),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(layout.radius.medium),
        ),
      ),
      sliderTheme: theme.sliderTheme.copyWith(year2023: false),
      appBarTheme: theme.appBarTheme.copyWith(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: scaffoldBackgroundColor,
      ),
      extensions: [layout],
    );
  }

  void unsaveCurrentTheme() {
    unsaveTheme(
      SavedTheme(
        customScheme: customScheme.value,
        useDynamicColor: useDynamic.value,
      ),
    );
  }

  void saveCurrentTheme() {
    saveTheme(
      SavedTheme(
        customScheme: customScheme.value,
        useDynamicColor: useDynamic.value,
      ),
    );
  }

  void saveTheme(SavedTheme theme) {
    if (savedThemes.value.contains(theme)) return;
    savedThemes.value.add(theme);
    savedThemes.refresh();
  }

  void unsaveTheme(SavedTheme theme) {
    savedThemes.value.remove(theme);
    savedThemes.refresh();
  }

  void loadSavedTheme(SavedTheme theme) {
    useDynamic.update(theme.useDynamicColor);
    customScheme.update(theme.customScheme);
  }
}
