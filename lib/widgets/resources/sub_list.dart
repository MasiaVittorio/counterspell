import 'package:counter_spell/core.dart';

class SubList extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SubList(this.title, {super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return SubSection(
      <Widget>[
        SectionTitle(title),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              for (final child in children)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: child,
                )
            ]),
          ),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }
}
