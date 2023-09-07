import 'package:counter_spell_new/core.dart';

class PieceOfInfo extends StatelessWidget {
  final String info;
  const PieceOfInfo(this.info);

  static const double height = 48.0;
  static const double left = 10;
  @override
  Widget build(BuildContext context) {
    return IconTheme.merge(
      data: const IconThemeData(opacity: 0.4),
      child: Container(
        height: height,
        alignment: Alignment.center,
        child: Row(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left:left),
            child: Container(
              width: height,
              height: height,
              alignment: Alignment.center,
              child: const Icon(Icons.keyboard_arrow_right),
            ),
          ),
          Expanded(
            child: Text(
              info, 
              maxLines: 2, 
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],),
      ),
    );
  }
}

class InfoSection extends StatelessWidget {
  final Icon icon;
  final bool first;
  final bool last;
  final String title;
  final List<String> info;
  const InfoSection({
    required this.icon,
    required this.title,
    required this.info,
    this.first = false,
    this.last = false,
  });

  static heightCalc(int infoNumber) => InfoTitle.height + infoNumber * PieceOfInfo.height + 14;
  double get height => heightCalc(info.length);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height + (first ? AlertDrag.height : 0.0) - (last ? 14.0 : 0.0),
      child: Section([
        InfoTitle(
          drag: first,
          icon: icon,
          title: title,
        ),
        for(final string in info)
          PieceOfInfo(string),
      ], last: last),
    );
  }
}

class InfoTitle extends StatelessWidget {
  final Icon icon;
  final String title;
  final bool drag;
  const InfoTitle({
    required this.icon,
    required this.title,
    required this.drag,
  });

  static const double height = 42.0;
  static const double width = 48.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height + (drag ? AlertDrag.height : 0.0),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if(drag) const AlertDrag(),
          Row(children: <Widget>[
            Container(
              width: width,
              height: height,
              alignment: Alignment.center,
              child: icon,
            ),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge, 
                maxLines: 2, 
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],),
        ],
      ),
    );
  }
}