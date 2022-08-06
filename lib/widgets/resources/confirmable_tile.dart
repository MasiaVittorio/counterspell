import 'package:sid_ui/sid_ui.dart';
import 'package:flutter/material.dart';

class ConfirmableTile extends StatefulWidget {
  const ConfirmableTile({
    required this.onConfirm,
    required this.titleBuilder,
    required this.subTitleBuilder,
    required this.leading,
  });

  final VoidCallback onConfirm;
  final Widget Function(BuildContext context, bool pressed) titleBuilder;
  final Widget Function(BuildContext context, bool pressed) subTitleBuilder;
  final Widget leading;

  @override
  State<ConfirmableTile> createState() => _ConfirmableTileState();
}

class _ConfirmableTileState extends State<ConfirmableTile> {
  bool pressed = false;
  int _pressId = 0;

  void cancel() => setState(() {
    pressed = false;
  });
  void confirm() {
    widget.onConfirm.call();
    cancel();
  }
  void press() {
    ++_pressId;
    setState(() {
      pressed = true;
    });
    wait(_pressId);
  }

  void wait(int id) async {
    await Future.delayed(const Duration(seconds: 2));
    if(mounted && id == _pressId) {
      cancel();
    } 
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.ease,
      color: pressed ? SubSection.getColor(theme) : theme.canvasColor,
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          onTap: pressed ? null : press,
          title: widget.titleBuilder.call(context, pressed),
          subtitle: widget.subTitleBuilder.call(context, pressed),
          leading: IconButton(
            icon: pressed ? const Icon(Icons.close) : widget.leading,
            onPressed: pressed ? cancel : press,
          ),
          trailing: pressed
            ? IconButton(
                icon: const Icon(Icons.check),
                onPressed: confirm,
              )
            : null,
        ),
      ),
    );
  }
}
