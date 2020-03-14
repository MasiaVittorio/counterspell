// import 'package:flutter/material.dart';


// class TextBolder extends StatelessWidget {

//   const TextBolder(this.text, {
//     this.style,
//     this.textAlign,
//   });

//   final String text;
//   final TextStyle style;
//   final TextAlign textAlign;

//   @override
//   Widget build(BuildContext context) {
//     final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
//     TextStyle effectiveTextStyle = style;

//     if (style == null || style.inherit)
//       effectiveTextStyle = defaultTextStyle.style.merge(style);

//     if (MediaQuery.boldTextOverride(context))
//       effectiveTextStyle = effectiveTextStyle.merge(const TextStyle(fontWeight: FontWeight.bold));

    

//     Widget result = RichText(
//       textAlign: textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
//       softWrap: defaultTextStyle.softWrap,
//       overflow: defaultTextStyle.overflow,
//       textScaleFactor: MediaQuery.textScaleFactorOf(context),
//       maxLines: defaultTextStyle.maxLines,
//       textWidthBasis: defaultTextStyle.textWidthBasis,
//       text: TextSpan(
//         style: effectiveTextStyle,
//         text: text,
//         children: textSpan != null ? <TextSpan>[textSpan] : null,
//       ),
//     );

//     return result;
//   }

//   static List<String> separate(String data) => data.split("*");

// }

