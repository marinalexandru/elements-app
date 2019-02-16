import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:elements/data/bloc_provider.dart';
import 'package:elements/data/blocs/auth_bloc.dart';
import 'package:elements/ui/screens/login/login_page.dart';
import 'package:elements/ui/screens/main/main_page.dart';
import 'package:elements/utils/color_theme.dart';
import 'package:elements/utils/strings.dart';
import 'package:rxdart/transformers.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  AuthBloc _bloc;

  StreamSubscription<bool> _subscription;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<AuthBloc>(context);
    _subscription = _bloc.auth
        .transform(DebounceStreamTransformer(Duration(seconds: 2)))
        .listen((authenticated) {
      if (authenticated) {
        _navigateToMainPage(context);
      } else {
        _navigateToLogin(context);
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration: _buildBackground(),
          child: _buildBody(),
        ),
      );

  _buildBackground() => BoxDecoration(
        color: ColorTheme.dark_blue_101A2C_alphaFF,
      );

  _buildBody() => Center(
        child: Opacity(
          opacity: 0.8,
          child: _buildSplashText(),
        ),
      );

  _buildSplashText() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            Strings.of(context).labelAppName.toUpperCase(),
            style: _buildTitleStyle(),
          ),
          Container(height: 10),
          Text(
            Strings.of(context).labelSubAppName.toUpperCase(),
            style: _buildSubtitleStyle(),
          )
        ],
      );

  _buildTitleStyle() => TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w900,
        letterSpacing: 15,
        fontSize: 30,
      );

  _buildSubtitleStyle() => TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
        letterSpacing: 16,
        fontSize: 14,
      );

  _navigateToMainPage(BuildContext context) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
      (r) => false);

  _navigateToLogin(BuildContext context) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (r) => false);
}
