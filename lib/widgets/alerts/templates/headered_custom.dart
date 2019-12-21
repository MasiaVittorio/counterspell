import 'package:counter_spell_new/core.dart';

class HeaderedAlertCustom extends StatelessWidget {
  final Widget title;
  final double titleSize;
  final Widget child;
  final Widget bottom;
  final bool alreadyScrollableChild;
  const HeaderedAlertCustom(this.title, {
    @required this.titleSize,
    @required this.child,
    this.bottom,
    this.alreadyScrollableChild = false,
  }): assert(alreadyScrollableChild != null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.scaffoldBackgroundColor,
      child: Stack(children: <Widget>[
        Positioned.fill(child: Column(children: <Widget>[

          Expanded(child: alreadyScrollableChild ? child : SingleChildScrollView(
            physics: Stage.of(context).panelScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(top: titleSize),
              child: child,
            ),
          ),),

          if(bottom != null)
            UpShadower(child: bottom,),

        ],),),

        Positioned(
          top: 0.0,
          height: titleSize,
          left: 0.0,
          right: 0.0,
          child: Container(
            color: theme.canvasColor.withOpacity(0.8),
            child: AlertTitleCustom(title),
          ),
        ),

      ],),
    );
  }
}