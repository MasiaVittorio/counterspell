import 'dart:convert';

import 'package:counter_spell/logic/theme_logic.dart';
import 'package:counter_spell/widgets/components/builders/double_map_builder.dart';
import 'package:counter_spell/widgets/components/builders/map_builder.dart';
import 'package:counter_spell/widgets/components/builders/triple_map_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:sid_base/sid_base.dart';

class SavedTheme {
  final CustomScheme customScheme;
  final bool useDynamicColor;

  SavedTheme({required this.customScheme, required this.useDynamicColor});

  SavedTheme copyWith({CustomScheme? customScheme, bool? useDynamicColor}) {
    return SavedTheme(
      customScheme: customScheme ?? this.customScheme,
      useDynamicColor: useDynamicColor ?? this.useDynamicColor,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'customScheme': customScheme.toMap(),
      'useDynamicColor': useDynamicColor,
    };
  }

  factory SavedTheme.fromMap(Map<String, dynamic> map) {
    return SavedTheme(
      customScheme: CustomScheme.fromMap(
        map['customScheme'] as Map<String, dynamic>,
      ),
      useDynamicColor: map['useDynamicColor'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SavedTheme.fromJson(String source) =>
      SavedTheme.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SavedTheme(customScheme: $customScheme, useDynamicColor: $useDynamicColor)';

  @override
  bool operator ==(covariant SavedTheme other) {
    if (identical(this, other)) return true;

    return other.customScheme == customScheme &&
        other.useDynamicColor == useDynamicColor;
  }

  @override
  int get hashCode => customScheme.hashCode ^ useDynamicColor.hashCode;
}

extension SavedThemeFromContext on BuildContext {
  Widget buildWithCurrentSavableTheme({
    required Widget Function(BuildContext context, SavedTheme saveableTheme)
    builder,
  }) {
    final logic = themeLogic;
    return (logic.useDynamic, logic.customScheme).build(
      (context, useDynamic, customScheme) => builder(
        context,
        SavedTheme(customScheme: customScheme, useDynamicColor: useDynamic),
      ),
    );
  }
}

class IsSavedThemeSelectedBuilder extends StatelessWidget {
  const IsSavedThemeSelectedBuilder({
    super.key,
    required this.savedTheme,
    required this.builder,
    this.child,
  });

  final SavedTheme savedTheme;
  final Widget? child;
  final Widget Function(BuildContext context, bool isSelected, Widget? child)
  builder;

  @override
  Widget build(BuildContext context) {
    final logic = context.themeLogic;
    return DoubleMapBuilder(
      reactiveA: logic.useDynamic,
      reactiveB: logic.customScheme,
      keys: [savedTheme],
      map: (a, b) =>
          SavedTheme(customScheme: b, useDynamicColor: a) == savedTheme,
      builder: builder,
      child: child,
    );
  }
}

class IsThemeSavedBuilder extends StatelessWidget {
  const IsThemeSavedBuilder({
    super.key,
    required this.savedTheme,
    required this.builder,
    this.child,
  });

  final SavedTheme savedTheme;
  final Widget? child;
  final Widget Function(BuildContext context, bool isSaved, Widget? child)
  builder;

  @override
  Widget build(BuildContext context) {
    final logic = context.themeLogic;
    return MapBuilder(
      reactive: logic.savedThemes,
      keys: [savedTheme],
      map: (a) => a.contains(savedTheme),
      builder: builder,
      child: child,
    );
  }
}

class IsCurrentThemeSavedBuilder extends StatelessWidget {
  const IsCurrentThemeSavedBuilder({
    super.key,
    this.child,
    required this.builder,
  });

  final Widget? child;
  final Widget Function(BuildContext context, bool isSaved, Widget? child)
  builder;

  @override
  Widget build(BuildContext context) {
    final logic = context.themeLogic;
    return TripleMapBuilder(
      reactiveA: logic.useDynamic,
      reactiveB: logic.customScheme,
      reactiveC: logic.savedThemes,
      map: (useDynamic, customScheme, savedThemes) {
        final check = SavedTheme(
          customScheme: customScheme,
          useDynamicColor: useDynamic,
        ).toJson();
        return savedThemes.any((element) => element.toJson() == check);
      },
      builder: builder,
      keys: [],
      child: child,
    );
  }
}
