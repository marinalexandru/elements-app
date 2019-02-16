import 'package:flutter/cupertino.dart';
import 'package:elements/utils/color_theme.dart';

class AppTitle extends StatelessWidget{

  final String _text;

  AppTitle(this._text);

  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      _text,
      style: TextStyle(
          fontSize: 24,
          color: ColorTheme.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 12
      ),
    ),
  );

}