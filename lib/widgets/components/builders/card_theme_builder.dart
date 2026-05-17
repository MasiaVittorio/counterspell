import 'dart:convert';
import 'dart:isolate';

import 'package:counter_spell/models/scryfall/card.dart';
import 'package:counter_spell/widgets/components/builders/card_builder.dart';
import 'package:counter_spell/widgets/components/builders/image_theme_builder/image_color_isolate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:sid_base/sid_base.dart';

class CardIdThemeBuilder extends StatelessWidget {
  const CardIdThemeBuilder({
    super.key,
    required this.id,
    required this.builder,
    this.child,
  });

  final String? id;
  final Widget Function(
    BuildContext context,
    MtgCard? card,
    ThemeData theme,
    Widget? child,
  )
  builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CardBuilder(
      id: id,
      child: child,
      builder: (context, MtgCard? card, child) {
        return CardThemeBuilder(
          card: card,
          child: child,
          builder: (context, theme, child) {
            return builder(context, card, theme, child);
          },
        );
      },
    );
  }
}

class CardThemeBuilder extends StatelessWidget {
  const CardThemeBuilder({
    super.key,
    required this.card,
    required this.builder,
    this.child,
  });

  final MtgCard? card;
  final Widget Function(BuildContext context, ThemeData theme, Widget? child)
  builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final appTheme = context.theme;
    return switch (card) {
      null => builder(context, appTheme, child),
      MtgCard card => _CardThemeBuilder(
        card: card,
        builder: builder,
        appTheme: appTheme,
        variant: DynamicSchemeVariant.vibrant,
        contrast: 0.1,
        child: child,
      ),
      // MtgCard card => context.themeLogic.customScheme.build((context, value) {
      //   return _CardThemeBuilder(
      //     card: card,
      //     builder: builder,
      //     appTheme: appTheme,
      //     variant: value.dynamicSchemeVariant,
      //     contrast: value.contrastLevel,
      //     child: child,
      //   );
      // }),
    };
  }
}

class _CardThemeBuilder extends StatefulWidget {
  const _CardThemeBuilder({
    required this.card,
    required this.builder,
    required this.appTheme,
    required this.variant,
    required this.contrast,
    required this.child,
  });

  final MtgCard card;
  final Widget Function(BuildContext context, ThemeData theme, Widget? child)
  builder;
  final Widget? child;

  final ThemeData appTheme;

  final DynamicSchemeVariant variant;
  final double contrast;

  @override
  State<_CardThemeBuilder> createState() => _CardThemeBuilderState();
}

class _CardThemeBuilderState extends State<_CardThemeBuilder> {
  late ColorScheme colorScheme;

  @override
  void initState() {
    super.initState();
    colorScheme = widget.card.colorSchemes(widget.appTheme).first;
    _updateColorScheme();
  }

  @override
  void didUpdateWidget(covariant _CardThemeBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.variant != widget.variant ||
        oldWidget.contrast != widget.contrast ||
        widget.appTheme.brightness != oldWidget.appTheme.brightness ||
        (oldWidget.card.id != widget.card.id)) {
      _updateColorScheme();
    }
  }

  String _id = '';
  void _updateColorScheme() async {
    final id = widget.card.id;
    _id = id;

    final imageUrl = widget.card.imageUrl();
    if (imageUrl == null) return;
    if (imageUrl.isEmpty) return;
    if (!mounted) return;

    ColorScheme? scheme;
    try {
      scheme = await compute(imageUrl);
    } catch (e) {
      debugPrint(
        '////// Error computing color scheme for card ${widget.card.name}: $e',
      );
    }
    if (scheme == null) return;

    if (!mounted) return;
    if (_id != id) return;
    setState(() {
      colorScheme = scheme!;
    });
  }

  Future<ColorScheme> compute(String imageUrl) async {
    final brightness = widget.appTheme.brightness;
    final variant = widget.variant;
    final contrast = widget.contrast;

    late final int color;
    final String colorCacheKey = 'cached_color_seed_$imageUrl';
    final cachedColor = await DefaultCacheManager().getFileFromCache(
      colorCacheKey,
    );
    if (cachedColor == null) {
      final FileInfo fileInfo =
          await DefaultCacheManager()
                  .getImageFile(imageUrl)
                  .firstWhere((event) => event is FileInfo)
              as FileInfo;

      // ignore: no_leading_underscores_for_local_identifiers
      Future<int> _compute() => IsolatedImageColor.computeColor(fileInfo);
      color = await Isolate.run(_compute);
      DefaultCacheManager().putFile(
        colorCacheKey,
        utf8.encode(color.toString()),
      );
    } else {
      final String colorString = await cachedColor.file.readAsString();
      color = int.tryParse(colorString) ?? 0xFFFF0000;
    }

    return ColorScheme.fromSeed(
      seedColor: Color(color),
      brightness: brightness,
      dynamicSchemeVariant: variant,
      contrastLevel: contrast,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      widget.appTheme.copyWith(colorScheme: colorScheme),
      widget.child,
    );
  }
}
