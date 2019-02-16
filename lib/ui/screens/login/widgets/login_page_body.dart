import 'package:flutter/material.dart';
import 'package:elements/data/blocs/auth_bloc.dart';
import 'package:elements/data/blocs/login_validation_bloc.dart';
import 'package:elements/ui/screens/login/widgets/rich_text_go_to_register.dart';
import 'package:elements/ui/reusables/app_raised_button.dart';
import 'package:elements/ui/reusables/app_text_field.dart';
import 'package:elements/ui/reusables/app_title.dart';
import 'package:elements/utils/strings.dart';

class LoginPageBody extends StatelessWidget {
  final LoginValidationBloc _validationBloc;
  final AuthBloc _authBloc;
  final VoidCallback onGoToRegister;

  LoginPageBody(this._validationBloc, this._authBloc, {this.onGoToRegister});

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: _authBloc.loading,
        initialData: false,
        builder: (c, s) =>
            NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overScroll) {
                overScroll.disallowGlow();
              },
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: AppTitle(Strings.of(context).labelLogin),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: _buildEmail(context, s.data),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: _buildPassword(context, s.data),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: _buildLogin(context, s.data),
                  ),
                  InkWell(
                    onTap: onGoToRegister,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: RichTextGoToRegister(),
                    ),
                  )
                ],
              ),
            ),
      );

  _buildEmail(context, loading) => StreamBuilder(
        stream: _validationBloc.email,
        builder: (context, snapshot) => AppTextField(
              label: Strings.of(context).labelEmail,
              hint: Strings.of(context).labelEmailHint,
              keyboardType: TextInputType.emailAddress,
              onChanged: (s) {
                _authBloc.emailSink.add(s);
                _validationBloc.emailSink.add(s);
              },
              enabled: !loading,
            ),
      );

  _buildPassword(context, loading) => StreamBuilder(
        stream: _validationBloc.password,
        builder: (context, snapshot) => AppTextField(
              label: Strings.of(context).labelPassword,
              hint: Strings.of(context).labelPasswordHint,
              obscureText: true,
              onChanged: (s) {
                _authBloc.passwordSink.add(s);
                _validationBloc.passwordSink.add(s);
              },
              enabled: !loading,
            ),
      );

  _buildLogin(context, loading) => StreamBuilder(
        stream: _validationBloc.enabled,
        initialData: false,
        builder: (c, AsyncSnapshot<bool> snapshot) {
          return AppRaisedButton(
            loading: loading,
            text: Strings.of(context).labelLogin,
            onPressed: snapshot.data ? () => _authBloc.signIn() : null,
          );
        },
      );
}
