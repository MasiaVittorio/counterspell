// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:counter_spell/logic/theme_logic.dart';
import 'package:counter_spell/widgets/components/common/new_animated_listed.dart';
import 'package:counter_spell/widgets/expanded_panel/game_page/expanded_page_list.dart';
import 'package:counter_spell/widgets/expanded_panel/theme_page/components/color_picker_tile.dart';
import 'package:counter_spell/widgets/expanded_panel/theme_page/components/color_source_slider.dart';
import 'package:counter_spell/widgets/expanded_panel/theme_page/components/contrast_slider.dart';
import 'package:counter_spell/widgets/expanded_panel/theme_page/components/theme_mode_switch.dart';
import 'package:counter_spell/widgets/expanded_panel/theme_page/components/theme_save_bottom_row.dart';
import 'package:counter_spell/widgets/expanded_panel/theme_page/components/variant_tile.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;

    return ExpandedPageList(
      bottom: const ThemeSaveBottomRow(),
      children: [
        const SectionTitle(
          title: Text('Brightness'),
          leading: Icon(Icons.brightness_4_outlined),
        ),
        const ThemeModeSwitch(),
        const SectionTitle(
          title: Text('Color source'),
          leading: Icon(Icons.palette_outlined),
        ),
        const ColorSourceSlider(),
        const SectionTitle(
          title: Text('Style'),
          leading: Icon(Icons.style_outlined),
        ),
        context.themeLogic.useDynamic.build(
          (context, useDynamic) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NewAnimatedListed(
                listed: !useDynamic,
                axisAlignment: 1,
                child: const GroupedCard(
                  isLast: false,
                  isFirst: true,
                  child: ColorPickerTile(),
                ),
              ),
              GroupedCard(
                isLast: false,
                isFirst: useDynamic,
                child: const VariantTile(),
              ),
              GroupedCard(
                isLast: true,
                isFirst: false,
                lastPadding: layout.margin.large,
                child: const ContrastSlider(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
