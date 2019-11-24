import 'package:flutter/material.dart';


class CSSlider extends StatefulWidget {
  final double min;
  final double max;
  final double value;
  final String Function(double) title;
  final void Function(double) onChangeEnd;
  final void Function(double) onChanged;
  final bool enabled;
  final Widget icon;
  final double restartTo;
  final bool bigTitle;

  CSSlider({
    @required this.value,
    this.onChangeEnd,
    this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.enabled = true,
    this.title,
    this.icon,
    this.restartTo,
    this.bigTitle = false,
  }): assert(min != null),
      assert(max != null),
      assert(bigTitle != null),
      assert(enabled != null),
      assert(value != null);
      
  @override
  _CSSliderState createState() => _CSSliderState();
}

class _CSSliderState extends State<CSSlider> {

  double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(CSSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.value != widget.value){
      this._value = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final slider = Slider(
      onChanged: widget.enabled
        ? (val){
          widget.onChanged?.call(val);
          this.setState((){
            this._value = val;
          });
        }
        : null,
      onChangeEnd: (val) => this.widget.onChangeEnd?.call(val),
      value: this._value,
      min: widget.min,
      max: widget.max,
    );

    if(widget.title != null){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if(widget.icon!=null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 24.0),
                    child:widget.icon,
                  ),
                Text(
                  widget.title(this._value),
                  style: widget.bigTitle 
                    ? Theme.of(context).textTheme.body2
                    : null,
                ),
                
                Spacer(),
                if(widget.restartTo!=null)
                  IconButton(
                    icon: Icon(Icons.settings_backup_restore),
                    onPressed: (){
                      this.setState((){
                        this._value = widget.restartTo;
                      });
                      widget.onChangeEnd(this._value);
                    },
                  ),
              ],
            ),
          ),
          slider,
        ],
      );
    }
    return slider;
  }
}