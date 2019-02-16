import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:elements/data/bloc_provider.dart';
import 'package:elements/data/blocs/auth_bloc.dart';
import 'package:elements/ui/screens/splash/splash_page.dart';
import 'package:elements/utils/color_theme.dart';
import 'package:elements/utils/strings.dart';

class LogoutButton extends StatefulWidget {
  @override
  _LogoutButtonState createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  final double iconSize = 23;
  AuthBloc _bloc;

  StreamSubscription<bool> _subscription;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<AuthBloc>(context);
    _subscription = _bloc.auth.listen((authenticated) {
      if (authenticated) {
        return;
      }
      _navigateToLogin(context);
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: _bloc.loading,
        initialData: false,
        builder: (c, s) => Container(
              decoration: _buildBackground(),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 13, right: 7, top: 13, bottom: 13),
                child: Opacity(
                  opacity: 0.8,
                  child: InkWell(
                    onTap: s.data ? null : () => askLogout(context),
                    child: _buildBody(s.data),
                  ),
                ),
              ),
            ),
      );

  _buildBackground() => BoxDecoration(
      border: Border(
        top: BorderSide(color: Colors.white, width: 0.5),
        left: BorderSide(color: Colors.white, width: 0.5),
        bottom: BorderSide(color: Colors.white, width: 0.5),
      ),
      color: Colors.black38);

  _buildBody(bool loading) => !loading
      ? Image(
          image: AssetImage("images/logout.png"),
          width: iconSize,
          height: iconSize,
          color: ColorTheme.white,
        )
      : Container(
          width: iconSize,
          height: iconSize,
          child: CupertinoActivityIndicator(),
        );

  _navigateToLogin(BuildContext context) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SplashPage()),
      (route) => false);

  void askLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text(
          Strings.of(context).labelLogoutQuestion,
          style: _buildContentTextStyle(),
        ),
        actions: [
          FlatButton(
            child: Text(
              Strings.of(context).labelOk.toString().toUpperCase(),
              style: _buildActionTextStyle(),
            ),
            onPressed: () => _bloc.logout(),
          ),
          FlatButton(
            child: Text(
              Strings.of(context).labelCancel.toString().toUpperCase(),
              style: _buildActionTextStyle(),
            ),
            onPressed: () => Navigator.pop(context),
          ),
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

}
