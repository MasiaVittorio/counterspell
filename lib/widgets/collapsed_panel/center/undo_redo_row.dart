import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/arena/components/can_undo_redo_builder.dart';
import 'package:counter_spell/widgets/components/common/square_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';

class UndoRedoRow extends StatelessWidget {
  const UndoRedoRow({super.key});

  @override
  Widget build(BuildContext context) {
    final size = context.panelFrameStyle.collapsedPanelHeight;
    final gameLogic = context.counterSpell.gameLogic;

    return CanUndoRedoBuilder(
      builder: (context, canUndo, canRedo, _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SquareIconButton(
            dimension: size,
            onPressed: canUndo ? gameLogic.back : null,
            icon: const Icon(Icons.undo),
          ),
          SquareIconButton(
            dimension: size,
            onPressed: canRedo ? gameLogic.forward : null,
            icon: const Icon(Icons.redo),
          ),
        ],
      ),
    );
  }
}
