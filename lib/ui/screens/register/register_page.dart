import 'dart:async';

import 'package:flutter/material.dart';
import 'package:elements/data/bloc_provider.dart';
import 'package:elements/data/blocs/auth_bloc.dart';
import 'package:elements/data/blocs/register_validation_bloc.dart';
import 'package:elements/ui/errors/display_error.dart';
import 'package:elements/ui/screens/main/main_page.dart';
import 'package:elements/ui/screens/register/widgets/register_page_body.dart';
import 'package:elements/utils/color_theme.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  RegisterValidationBloc _validationBloc;
  AuthBloc _authBloc;

  StreamSubscription<bool> _subscription;

  @override
  void initState() {
    super.initState();
    _validationBloc = RegisterValidationBloc();
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
          child: _buildBody(),
        ),
      );

  _buildBackground() => BoxDecoration(
        color: ColorTheme.dark_blue_101A2C_alphaFF,
      );

  _buildBody() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Container(
          alignment: Alignment.center,
          child: RegisterPageBody(
            _validationBloc,
            _authBloc,
            _navigateBack,
          ),
        ),
      );

  _navigateToMainPage(BuildContext context) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
      (r) => true);

  _navigateBack() => Navigator.pop(context);
}
