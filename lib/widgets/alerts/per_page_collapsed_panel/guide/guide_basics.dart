import 'package:counter_spell_new/core.dart';

class PieceOfInfo extends StatelessWidget {
  final String info;
  const PieceOfInfo(this.info);

  static const double height = 48.0;
  static const double left = 10;
  @override
  Widget build(BuildContext context) {
    return IconTheme.merge(
      data: IconThemeData(opacity: 0.4),
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
  final String title;
  final List<String> info;
  const InfoSection({
    @required this.icon,
    @required this.title,
    @required this.info,
  });

  static heightCalc(int infoNumber) => InfoTitle.height + infoNumber * PieceOfInfo.height + 14;
  double get height => heightCalc(this.info.length);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Section([
        InfoTitle(
          icon: icon,
          title: title,
        ),
        for(final string in this.info)
          PieceOfInfo(string),
      ],),
    );
  }
}

class InfoTitle extends StatelessWidget {
  final Icon icon;
  final String title;
  const InfoTitle({
    @required this.icon,
    @required this.title,
  });

  static const double height = 42.0;
  static const double width = 48.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      child: Row(children: <Widget>[
        Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          child: this.icon,
        ),
        Expanded(
          child: Text(
            this.title,
            style: Theme.of(context).textTheme.body2, 
            maxLines: 2, 
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],),
    );
  }
}