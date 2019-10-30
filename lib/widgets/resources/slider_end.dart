import 'package:flutter/material.dart';


class CSSliderEnd extends StatefulWidget {
  final double min;
  final double max;
  final double value;
  final String Function(double) title;
  final void Function(double) onChangeEnd;
  final bool enabled;

  CSSliderEnd({
    @required this.value,
    @required this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.enabled = true,
    this.title,
  }): assert(min != null),
      assert(max != null),
      assert(enabled != null),
      assert(value != null),
      assert(onChangeEnd != null);

  @override
  _CSSliderEndState createState() => _CSSliderEndState();
}

class _CSSliderEndState extends State<CSSliderEnd> {

  double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(CSSliderEnd oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.value != widget.value){
      this._value = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final slider = Slider(
      onChanged: widget.enabled
        ? (val)=> this.setState((){
          this._value = val;
        })
        : null,
      onChangeEnd: (val) => this.widget.onChangeEnd(val),
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
            padding: const EdgeInsetsDirectional.only(start: 24.0),
            child: Text(
              widget.title(this._value),
            ),
          ),
          slider,
        ],
      );
    }
    return slider;
  }
}