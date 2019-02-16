import 'package:flutter/material.dart';
import 'package:elements/utils/color_theme.dart';
import 'package:elements/utils/strings.dart';

class RichTextGoToRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) => RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: Strings.of(context).labelNoAccount,
            style: TextStyle(
              letterSpacing: 1.3,
              color: ColorTheme.gray_a4b1c7,
              fontSize: 14,
            ),
            children: [
              TextSpan(
                  text: Strings.of(context).labelHere,
                  style: TextStyle(
                    letterSpacing: 1.3,
                    color: Colors.white,
                    fontSize: 14,
                  ))
            ]),
      );
}
