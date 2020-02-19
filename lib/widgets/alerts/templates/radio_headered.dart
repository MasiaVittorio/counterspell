import 'package:counter_spell_new/core.dart';

class RadioHeaderedItem extends RadioNavBarItem {
  final Widget child;
  final String longTitle;
  final bool alreadyScrollableChild;
  final double extraOffset;

  const RadioHeaderedItem({
    @required this.longTitle,
    @required this.child,
    String title,
    @required IconData icon,
    IconData unselectedIcon,
    Color color,
    double iconSize,
    this.extraOffset = 0.0,
    this.alreadyScrollableChild = false,
  }): super(
    title: title ?? longTitle,
    icon: icon,
    unselectedIcon: unselectedIcon,
    color: color,
    iconSize: iconSize,
  );
}

class RadioHeaderedAlert<T> extends StatefulWidget {

  final Map<T,RadioHeaderedItem> items;
  final T initialValue;
  final List<T> orderedValues;
  final Color bottomAccentColor;
  final bool accentSelected;
  final bool animatedSwitch;
  final void Function(T) onPageChanged;

  const RadioHeaderedAlert({
    @required this.initialValue,
    @required this.orderedValues,
    this.bottomAccentColor,
    bool accentSelected = false,
    @required this.items,
    this.animatedSwitch = true,
    this.onPageChanged,
  }): this.accentSelected = (bottomAccentColor != null) || accentSelected;

  @override
  _RadioHeaderedAlertState<T> createState() => _RadioHeaderedAlertState<T>();
}

class _RadioHeaderedAlertState<T> extends State<RadioHeaderedAlert<T>> {

  T value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return _RadioHeaderedAlertWidget(
      selectedValue: this.value, 
      orderedValues: widget.orderedValues, 
      onSelect: (v) => this.setState((){
        this.value = v;
        this.widget.onPageChanged?.call(v);
      }), 
      items: widget.items,
      animatedSwitch: widget.animatedSwitch,
      bottomAccentColor: widget.bottomAccentColor,
      accentSelected: widget.accentSelected ?? false,
    );
  }
}


class _RadioHeaderedAlertWidget<T> extends StatelessWidget {
  final Map<T,RadioHeaderedItem> items;
  final T selectedValue;
  final List<T> orderedValues;
  final void Function(T) onSelect;
  final Color bottomAccentColor;
  final bool accentSelected;
  final animatedSwitch;

  const _RadioHeaderedAlertWidget({
    @required this.selectedValue,
    @required this.orderedValues,
    @required this.onSelect,
    @required this.animatedSwitch,
    this.bottomAccentColor,
    bool accentSelected = false,
    @required this.items,
  }): this.accentSelected = (bottomAccentColor != null) || accentSelected;


  @override
  Widget build(BuildContext context) {

    final Widget Function(T) itemChild = (T item) => items[item].alreadyScrollableChild 
      ? items[item].child 
      : SingleChildScrollView(
        physics: Stage.of(context).panelScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: AlertTitle.height),
          child: items[item].child,
        ),
      );

    final Widget navBar = RadioNavBar<T>(
      selectedValue: selectedValue,
      orderedValues: orderedValues,
      items: {for(final entry in items.entries) 
        entry.key : RadioNavBarItem(
          title: entry.value.title,
          icon: entry.value.icon,
          unselectedIcon: entry.value.unselectedIcon,
          color: entry.value.color,
          iconSize: entry.value.iconSize,
        ),
      },
      onSelect: this.onSelect,
      accentTextColor: this.accentSelected 
        ? this.bottomAccentColor ?? Theme.of(context).accentColor
        : null,
    );

    return HeaderedAlert(
      this.items[selectedValue].longTitle,
      child: Stack(fit: StackFit.expand, children: <Widget>[
        if(this.animatedSwitch) for(final T item in this.orderedValues)
          Positioned.fill(
            top: -items[item].extraOffset, 
            child: AnimatedPresented(
              duration: const Duration(milliseconds: 215),
              presented: item == selectedValue,
              curve: Curves.fastOutSlowIn.flipped,
              presentMode: PresentMode.slide,
              child: itemChild(item),
            ),
          )
        else 
          Positioned.fill(
            top: -items[selectedValue].extraOffset, 
            child: itemChild(selectedValue),
          ),
      ],), 
      alreadyScrollableChild: true,
      bottom: navBar,
    );
  }
}