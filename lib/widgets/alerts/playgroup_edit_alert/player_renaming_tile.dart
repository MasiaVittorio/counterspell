import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class PlayerRenamingTile extends StatelessWidget {
  const PlayerRenamingTile({
    super.key,
    required this.name,
    required this.index,
    required this.length,
    required this.onRename,
    required this.onDelete,
    required this.frame,
    required this.canDelete,
    required this.spacing,
    required this.canReorder,
  });

  final bool canReorder;
  final String name;
  final int index;
  final int length;

  final VoidCallback onDelete;
  final VoidCallback onRename;
  final PanelFrameState frame;
  final double spacing;
  final bool canDelete;

  static const double height = 56.0;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;

    return Pad(
      horizontal: layout.margin.medium,
      vertical: spacing / 2,
      child: Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: GroupedCard.borderRadius(
          layout,
          isFirst: index == 0,
          isLast: index == length - 1,
        ),
        color: theme.colorScheme.surfaceContainerHigh,
        child: InkWell(
          onTap: onRename,
          child: SizedBox(
            height: height,
            child: Row(
              children: [
                if (canDelete)
                  SizedBox.square(
                    dimension: height,
                    child: InkResponse(
                      onTap: () {
                        frame.showAlert(
                          ConfirmPanelAlert.delete(
                            title: Text('Remove $name'),
                            confirmLabel: const Text('Remove'),
                            onConfirmed: () {
                              onDelete();
                              // frame.closePanel();
                            },
                          ),
                        );
                      },
                      child: Icon(
                        Icons.delete_forever_outlined,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  )
                else
                  Space.horizontal(layout.margin.medium),
                Expanded(child: Text(name, style: theme.textTheme.titleMedium)),
                if (canReorder)
                  ReorderableDragStartListener(
                    index: index,
                    child: const SizedBox.square(
                      dimension: height,
                      child: Center(child: Icon(Icons.unfold_more)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
