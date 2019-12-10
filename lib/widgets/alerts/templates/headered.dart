import 'package:counter_spell_new/core.dart';

class HeaderedAlert extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget bottom;
  final bool alreadyScrollableChild;
  const HeaderedAlert(this.title, {
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
              padding: const EdgeInsets.only(top: AlertTitle.height),
              child: child,
            ),
          ),),

          if(bottom != null)
            UpShadower(child: bottom,),

        ],),),

        Positioned(
          top: 0.0,
          height: AlertTitle.height,
          left: 0.0,
          right: 0.0,
          child: Container(
            color: theme.scaffoldBackgroundColor.withOpacity(0.7),
            child: AlertTitle(title, animated: true),
          ),
        ),

      ],),
    );
  }
}