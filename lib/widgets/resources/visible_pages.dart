import 'package:counter_spell_new/core.dart';
import 'package:flutter/material.dart';


// not really sure what this is for
class VisiblePages extends StatelessWidget {
  final List<Widget> children;
  final double viewFraction;

  VisiblePages({
    required this.children,
    this.viewFraction = 0.7,
  }): assert(children != null && children.isNotEmpty),
      assert(viewFraction != null);

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {
        final double childSize = viewFraction * constraints.maxWidth;

         return ConstrainedBox(
          constraints: constraints,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[for(int i = 0; i < children.length; ++i)
                SizedBox(
                  width: childSize,
                  child: children[i], 
                ),
              ],
            ),
          ),
         );

      }
    );
  }

}


