import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:elements/utils/color_theme.dart';
import 'package:elements/utils/strings.dart';

class AppRaisedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool loading;

  AppRaisedButton({this.text, this.onPressed, this.loading });

  @override
  Widget build(BuildContext context) => RaisedButton(
        onPressed: !loading ? onPressed : null,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(7.0)),
        splashColor: ColorTheme.dark_blue_384A64_alpha22,
        color: ColorTheme.white,
        disabledColor: ColorTheme.white_DDDDDD,
        child: !loading
            ? Padding(
                padding: const EdgeInsets.all(15.0),
                child: _buildText(text, onPressed),
              )
            : Padding(
                padding: const EdgeInsets.all(13.0),
                child: _buildLoading(context),
              ),
      );
}

_buildLoading(context) {
  return Opacity(
    opacity: 0.65,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CupertinoActivityIndicator(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
          child: Text(
            Strings.of(context).labelLoading,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: ColorTheme.dark_blue_101A2C_alphaFF,
              letterSpacing: 2,
              fontSize: 12,
            ),
          ),
        ),
      ],
    ),
  );
}

_buildText(text, onPressed) {
  return Text(
    text,
    style: TextStyle(
      letterSpacing: 3,
      fontWeight: FontWeight.w900,
      color: onPressed != null
          ? ColorTheme.dark_blue_101A2C_alphaFF
          : ColorTheme.gray_555555,
      fontSize: 12,
    ),
  );
}
