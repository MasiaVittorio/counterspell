import 'package:counter_spell_new/core.dart';

class AlertTitle extends StatelessWidget {
  final String title;
  final bool centered;
  const AlertTitle(this.title, {this.centered = true}):
    assert(centered != null);

  static const double _minHeight = 30.0;

  static const double height = AlertComponents.drag ? _minHeight + AlertDrag.height : _minHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = DefaultTextStyle.of(context).style;

    final title = Container(
      height: _minHeight,
      alignment: this.centered 
        ? Alignment.center 
        : AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          this.title,
          maxLines: 1, 
          overflow: TextOverflow.ellipsis,
          style: style.copyWith(
            color: RightContrast(
              theme, 
              fallbackOnTextTheme: true
            ).onCanvas,
            fontWeight: incrementFontWeight[style.fontWeight],
          ),
        ),
      ),
    );

    return Container(
      alignment: Alignment.center,
      height: height,
      child: AlertComponents.drag 
        ? Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const AlertDrag(),
            title,
          ],
        )
        : title,
    );
  }
}