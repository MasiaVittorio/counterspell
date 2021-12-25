import '../all.dart';

class GALife extends GameAction{
  final Map<String,bool?> selected;
  final int increment;
  final int? minVal;
  final int? maxVal;

  const GALife(
    this.increment, {
      required this.selected,
      this.minVal,
      this.maxVal,
    }
  );

  @override
  Map<String, PlayerAction> actions(names) => {
    for(final name in names)
      name: !selected.containsKey(name)
        ? PANull.instance
        : selected[name] == false 
          ? PANull.instance
          : PALife(
            selected[name] == null 
              ? -increment
              : increment, // true
            maxVal: maxVal,
            minVal: minVal,
          ),
  };


}