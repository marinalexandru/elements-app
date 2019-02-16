import 'dart:async';

import 'package:flutter/material.dart';
import 'package:elements/data/bloc_provider.dart';
import 'package:elements/data/blocs/auth_bloc.dart';
import 'package:elements/data/blocs/login_validation_bloc.dart';
import 'package:elements/ui/errors/display_error.dart';
import 'package:elements/ui/screens/login/widgets/login_page_body.dart';
import 'package:elements/ui/screens/main/main_page.dart';
import 'package:elements/ui/screens/register/register_page.dart';
import 'package:elements/utils/color_theme.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  AuthBloc _authBloc;
  LoginValidationBloc _validationBloc;
  StreamSubscription<bool> _subscription;

  @override
  void initState() {
    super.initState();
    _validationBloc = LoginValidationBloc();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _subscription = _authBloc.auth
        .listen((success) => success ? _navigateToMainPage(context) : null);
    _subscription.onError((e) => displayError(e, context));
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          decoration: _buildBackground(),
          child: _buildBody(context),
        ),
      );

  _buildBackground() => BoxDecoration(
        color: ColorTheme.dark_blue_101A2C_alphaFF,
      );

  _buildBody(context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Container(
          alignment: Alignment.center,
          child: LoginPageBody(
            _validationBloc,
            _authBloc,
            onGoToRegister: () => _navigateToRegister(context),
          ),
        ),
      );

  _navigateToMainPage(BuildContext context) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
      (r) => false);

  _navigateToRegister(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => RegisterPage()));
}
