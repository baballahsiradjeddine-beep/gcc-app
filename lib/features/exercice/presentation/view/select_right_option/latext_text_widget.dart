import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
// import 'package:flutter_math_fork/flutter_math.dart';
import 'package:tayssir/debug/app_logger.dart';

class LatextTextWidget extends StatelessWidget {
  final int id;
  final String text;
  final bool isLatex;
  final TextAlign? textAlign;
  final FontWeight fontWeight;
  // final int? color;
  final TextStyle textStyle;
  final bool useFittedBox;
  final TextOverflow? overflow;
  final int? maxLines;
  final Function(int id)? onLatexTap;
  const LatextTextWidget({
    super.key,
    this.id = 0,
    required this.text,
    required this.isLatex,
    required this.textStyle,
    this.textAlign,
    this.fontWeight = FontWeight.w700,
    this.overflow,
    this.useFittedBox = false,
    this.maxLines,
    this.onLatexTap,
  });

  @override
  Widget build(BuildContext context) {
    AppLogger.logInfo('LatextTextWidget: $text, isLatex: $isLatex');
    if (isLatex) {
      return TeXView(
        key: Key(text),
        // loadingWidgetBuilder: (context) => const Center(
        //   child: CircularProgressIndicator(),
        // ),
        child: TeXViewInkWell(
          id: text,
          rippleEffect: false,
          onTap: (String id) {
            if (onLatexTap != null) {
              onLatexTap!(this.id);
            }
          },
          child: TeXViewDocument(text,
              style: const TeXViewStyle.fromCSS(
                  'padding: 0px;  direction: rtl;   text-align: center;')),
        ),
        style: TeXViewStyle(
          // textAlign: TeXViewTextAlign.center,
          contentColor: textStyle.color ?? Colors.black,
          textAlign: textAlign == null
              ? null
              : textAlign == TextAlign.center
                  ? TeXViewTextAlign.center
                  : textAlign == TextAlign.right
                      ? TeXViewTextAlign.right
                      : TeXViewTextAlign.left,
          fontStyle: TeXViewFontStyle(
            fontSize: textStyle.fontSize?.toInt() ?? 14,
            fontWeight: TeXViewFontWeight.bold,

            // fontFamily: 'Cairo',
          ),
        ),
      );

      // return Directionality(
      //     textDirection: TextDirection.ltr,
      //     child: LaTexT(
      //         // breakDelimiter: '\\',
      //         delimiter: r'$',
      //         displayDelimiter: r'$$',
      //         laTeXCode: Text(text,
      //             textDirection: TextDirection.rtl,
      //             textAlign: TextAlign.center,
      //             style: textStyle))
      //     // child: Center(
      //     //   child: Math.tex(
      //     //     latexInput,
      //     //     textStyle: textStyle,

      //     //     mathStyle: MathStyle.scriptscript,

      //     //     // add overflow
      //     //     // settings: TexParserSettings(

      //     //     // mathStyle: MathStyle.display,
      //     //     // mathFontOptions: const FontOptions(
      //     //     // fontFamily: 'Cairo',
      //     //     //   fontWeight: FontWeight.w700,
      //     //     // ),
      //     //     // ),
      //     //     options: MathOptions(
      //     //       mathFontOptions: const FontOptions(
      //     //           // fontFamily: 'SansSomar',
      //     //           ),
      //     //       // style: MathStyle.display,

      //     //       // displayMode: false,
      //     //       // mathFontOptions: const FontOptions(
      //     //       //   fontFamily: 'Cairo',
      //     //       //   fontWeight: FontWeight.w700,
      //     //       // ),
      //     //     ),
      //     //   ),
      //     // ),
      //     );
    } else {
      return useFittedBox
          ? FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                // style: TextStyle(
                //   color: Color(color!),
                //   fontWeight: fontWeight,
                // ),
                style: textStyle,
                textAlign: textAlign,
                overflow: overflow,
                maxLines: maxLines,
              ),
            )
          : Text(
              text,
              // style: TextStyle(
              //   color: Color(color!),
              //   fontWeight: fontWeight,
              // ),
              style: textStyle,
              textAlign: textAlign,
              overflow: overflow,
              maxLines: maxLines,
            );
    }
  }
}
