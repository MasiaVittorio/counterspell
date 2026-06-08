import 'package:counter_spell/widgets/components/builders/can_use_arena_view_builder.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class ExpandedPageList extends StatelessWidget {
  const ExpandedPageList({
    super.key,
    required this.children,
    required this.bottom,
  });

  final List<Widget> children;
  final Widget bottom;

  @override
  Widget build(BuildContext context) {
    final wrappedBottom = PanelListBottomElement(
      overrideBottomMargin: context.theme.layout.padding.smaller,
      child: bottom,
    );
    const header = PanelHeader();
    final panelFrame = context.panelFrame;
    return Stack(
      children: [
        Positioned.fill(
          child: UsesArenaViewBuilder(
            child: header,
            builder: (context, usesArenaView, header) {
              return ListView(
                padding: EdgeInsets.only(
                  top: usesArenaView ? 0 : context.safe.top,
                ),
                physics: CallbackScrollPhysics(
                  topBounceCallback: () => panelFrame.closePanel(),
                  topBounce: true,
                  alwaysScrollable: false,
                ),
                children: [
                  if (usesArenaView) Opacity(opacity: 0, child: header),
                  ...children,
                  Opacity(
                    opacity: 0,
                    child: IgnorePointer(ignoring: true, child: wrappedBottom),
                  ),
                ],
              );
            },
          ),
        ),
        Positioned(left: 0, right: 0, bottom: 0, child: wrappedBottom),
      ],
    );
  }
}
