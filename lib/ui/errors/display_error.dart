import 'package:flutter/material.dart';
import 'package:elements/data/errors/app_error.dart';
import 'package:elements/utils/color_theme.dart';
import 'package:elements/utils/strings.dart';

void displayError(AppError e, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
          content: Text(
            Strings.of(context).labelErrorPrefix + getError(e, context),
            style: _buildContentTextStyle(),
          ),
          actions: [
            FlatButton(
              child: Text(
                Strings.of(context).labelOk.toString().toUpperCase(),
                style: _buildActionTextStyle(),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
  );
}

_buildContentTextStyle() => TextStyle(
      color: ColorTheme.dark_blue_101A2C_alphaFF,
      fontSize: 15,
      letterSpacing: 2,
      fontWeight: FontWeight.bold,
    );

_buildActionTextStyle() => TextStyle(
      color: ColorTheme.dark_blue_101A2C_alphaFF,
      fontSize: 12,
      letterSpacing: 2,
      fontWeight: FontWeight.bold,
    );

String getError(AppError error, BuildContext context) {
  switch (error.code) {
    case ErrorCode.invalidEmail:
      return Strings.of(context).errorInvalidEmail;
    case ErrorCode.passwordLength:
      return Strings.of(context).errorPasswordLength;
    case ErrorCode.passwordMatch:
      return Strings.of(context).errorPasswordMatch;
    case ErrorCode.errorUserAlreadyRegistered:
      return Strings.of(context).errorUserAlreadyRegistered;
    case ErrorCode.errorInvalidCredentials:
      return Strings.of(context).errorInvalidCredentials;
    case ErrorCode.errorAnonymousSignInNotAllowed:
      return Strings.of(context).errorAnonymousSignInNotAllowed;
    case ErrorCode.errorWeakPassword:
      return Strings.of(context).errorWeakPassword;
    case ErrorCode.processingError:
    default:
      return Strings.of(context).errorGeneralError;
  }
}
