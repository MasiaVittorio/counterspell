import 'package:counter_spell/logic/theme_logic.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class VariantTile extends StatelessWidget {
  const VariantTile({super.key});

  @override
  Widget build(BuildContext context) {
    final themeLogic = context.provide<ThemeLogic>();

    return themeLogic.customScheme.build((context, customScheme) {
      final value = customScheme.dynamicSchemeVariant;
      void onChanged(DynamicSchemeVariant v) {
        themeLogic.customScheme.update(
          customScheme.copyWith(dynamicSchemeVariant: v),
        );
      }

      return ListTile(
        trailing: IconButton(
          onPressed: () => onChanged(DynamicSchemeVariant.tonalSpot),
          icon: const Icon(Icons.restart_alt),
        ),
        title: Text('Dynamic scheme variant'.todo),
        subtitle: Text(value.name.capitalizeFirst),
        onTap: needsConfirmation
            ? () async {
                final result = await context.panelFrame.showAlert(
                  ThemeVariantPanelPicker(initialVariant: value, height: 700),
                );
                if (!context.mounted) return;
                if (result case DynamicSchemeVariant v) {
                  onChanged(v);
                }
              }
            : () => context.panelFrame.showAlert(
                ThemeVariantPanelPicker(
                  initialVariant: value,
                  height: 700,
                  confirmationMode: SelectAndConfirm(
                    onUnconfirmedSelection: (v) {
                      if (v != null) onChanged(v);
                    },
                  ),
                ),
              ),
      );
    });
  }

  static const bool needsConfirmation = false;
}
