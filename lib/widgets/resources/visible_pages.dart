import 'package:counter_spell_new/core.dart';
import 'package:flutter/material.dart';

class VisiblePages extends StatelessWidget {
  final List<Widget> children;
  final double viewFraction;
  final int initialPage;

  VisiblePages({
    @required this.children,
    this.viewFraction = 0.7,
    this.initialPage = 0,
  }): assert(children != null && children.isNotEmpty),
      assert(viewFraction != null),
      assert(initialPage != null);

  // AnimationController controller;

  // @override
  // void initState() {
  //   super.initState();
  //   controller = AnimationController(
  //     value: widget.initialPage?.toDouble() ?? 0.0,
  //     vsync: this,
  //     lowerBound: 0.0,
  //     upperBound: widget.children.length - 1.0,
  //   );
  // }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {
        final double childSize = viewFraction * constraints.maxWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[for(int i = 0; i < children.length; ++i)
              SizedBox(
                width: childSize,
                child: children[i], 
                // InkWell(
                //   child: children[i],
                //   onTap: () => this.controller.animateTo(i + 0.0, duration: CSAnimations.fast, curve: Curves.easeIn),
                // ),
              ),
            ],
          ),
        );

        // return Stack(
        //   children: <Widget>[
        //     AnimatedBuilder(
        //       animation: controller,
        //       child: child,
        //       builder: (_, child) =>Positioned(
        //         top: 0.0,
        //         bottom: 0.0,
        //         left: calcOffset(childSize, constraints.maxWidth, len, controller.value),
        //         child: child,
        //       ),
        //     ),
        //     child,
        //   ],
        // );
      }
    );
  }

  // static double calcOffset(double childSize, double maxSize, int len, double page){
  //   final double maxExcess = maxSize - childSize;
  //   final double excess = maxExcess / 2;
  //   final double totalChildrenSize = childSize * len;

  //   final double finalOffset = - totalChildrenSize + maxSize;
  //   final double preFinalOffset = finalOffset + childSize - excess;

  //   final double secondOffset = len == 2 ? finalOffset : 0 - childSize + excess;

  //   if(page <= 1){
  //     // 0 -> 0
  //     // 1 -> secondOffset
  //     return mapDoubleRange(
  //       page, 
  //       0, 
  //       secondOffset,
  //     );
  //   } else if(page >= len - 2){
  //     // len - 2 -> preFinalOffset
  //     // len - 1 -> finalOffset 
  //     return mapDoubleRange(
  //       page, 
  //       preFinalOffset, 
  //       finalOffset, 
  //       fromMin: len - 2.0, 
  //       fromMax: len - 1.0,
  //     );
  //   } else {
  //     // 1 -> secondOffset
  //     // len - 2 -> preFinalOffset
  //     return mapDoubleRange(
  //       page, 
  //       secondOffset, 
  //       preFinalOffset,
  //       fromMin: 1.0,
  //       fromMax: len - 2.0,
  //     );
  //   }

  // }


}


