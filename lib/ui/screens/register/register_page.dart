import 'dart:async';

import 'package:flutter/material.dart';
import 'package:elements/data/bloc_provider.dart';
import 'package:elements/data/blocs/auth_bloc.dart';
import 'package:elements/data/blocs/register_validation_bloc.dart';
import 'package:elements/ui/screens/register/widgets/register_page_body.dart';
import 'package:elements/utils/color_theme.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  RegisterValidationBloc _validationBloc;
  AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _validationBloc = RegisterValidationBloc();
    _authBloc = BlocProvider.of<AuthBloc>(context);
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

  _navigateBack() => Navigator.pop(context);
}
