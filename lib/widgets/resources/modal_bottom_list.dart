import 'package:flutter/material.dart';


/// A list made to be scrollable if needed, but to put a single child at 
/// the bottom of the screen if there is more than enough space.
/// Very cheap to build but the catch is you have to provide the bottom size 
class ModalBottomList extends StatelessWidget {

  const ModalBottomList({
    Key? key,
    required this.children,
    required this.bottom,
    required this.bottomHeight,
    this.physics,
  }) : super(key: key);

  final Widget bottom;
  final double bottomHeight;
  final List<Widget> children;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => ConstrainedBox(
        constraints: constraints,
        child: SingleChildScrollView(
          physics: physics,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth,
                  minWidth: constraints.minWidth,
                  minHeight: constraints.maxHeight - bottomHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: children,
                ),
              ),
              SizedBox(
                height: bottomHeight,
                child: Center(child: bottom),
              ),
            ],
          ),
        ),
      ),
    );
  }
}