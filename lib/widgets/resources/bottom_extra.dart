import 'package:counter_spell/core.dart';

class BottomExtra extends StatelessWidget {
  final Widget text;
  final VoidCallback onTap;
  final IconData? icon;
  const BottomExtra(this.text, {super.key, required this.onTap, this.icon});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          height: 40,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              DefaultTextStyle(
                style: TextStyle(
                  inherit: true,
                  fontWeight: FontWeight.bold,
                  color: RightContrast(Theme.of(context)).onCanvas,
                ),
                child: text,
              ),
              if (icon != null) Icon(icon),
            ],
          ),
        ),
      );
}
