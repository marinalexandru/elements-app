import 'package:flutter/material.dart';
import 'package:elements/data/blocs/auth_bloc.dart';
import 'package:elements/data/blocs/register_validation_bloc.dart';
import 'package:elements/ui/errors/display_error.dart';
import 'package:elements/ui/screens/register/widgets/rich_text_go_to_login.dart';
import 'package:elements/ui/reusables/app_raised_button.dart';
import 'package:elements/ui/reusables/app_text_field.dart';
import 'package:elements/ui/reusables/app_title.dart';
import 'package:elements/utils/strings.dart';

class RegisterPageBody extends StatelessWidget {
  final RegisterValidationBloc _formBloc;
  final AuthBloc _authBloc;
  final VoidCallback onGoToLogin;

  RegisterPageBody(this._formBloc, this._authBloc, this.onGoToLogin);

  @override
  Widget build(BuildContext context) => StreamBuilder(
        initialData: false,
        stream: _authBloc.loading,
        builder: (c, s) => ListView(
          shrinkWrap: true,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: AppTitle(Strings.of(context).labelRegister),
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
                  padding: const EdgeInsets.only(bottom: 15),
                  child: _buildRepeatPassword(context, s.data),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: _buildRegister(context, s.data),
                ),InkWell(
                  onTap: onGoToLogin,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: RichTextGoToLogin(),
                  ),
                )
              ],
            ),
      );

  _buildEmail(context, loading) => StreamBuilder(
        stream: _formBloc.email,
        builder: (c, s) => AppTextField(
              onChanged: (s) {
                _authBloc.emailSink.add(s);
                _formBloc.emailSink.add(s);
              },
              label: Strings.of(context).labelEmail,
              hint: Strings.of(context).labelEmailHint,
              error: s.hasError ? getError(s.error, context) : null,
              keyboardType: TextInputType.emailAddress,
              enabled: !loading,
            ),
      );

  _buildPassword(context, loading) => StreamBuilder(
        stream: _formBloc.password,
        builder: (c, s) => AppTextField(
              onChanged: (s) {
                _authBloc.passwordSink.add(s);
                _formBloc.passwordSink.add(s);
              },
              label: Strings.of(context).labelPassword,
              hint: Strings.of(context).labelPasswordHint,
              error: s.hasError ? getError(s.error, context) : null,
              obscureText: true,
              enabled: !loading,
            ),
      );

  _buildRepeatPassword(context, loading) => StreamBuilder(
        stream: _formBloc.repeatPassword,
        builder: (c, s) {
          return AppTextField(
            onChanged: (s) => _formBloc.repeatPasswordSink.add(s),
            label: Strings.of(context).labelRepeatPassword,
            hint: Strings.of(context).labelRepeatPasswordHint,
            error: s.hasError ? getError(s.error, context) : null,
            obscureText: true,
            enabled: !loading,
          );
        },
      );

  _buildRegister(context, loading) => StreamBuilder(
        stream: _formBloc.enabled,
        initialData: false,
        builder: (c, AsyncSnapshot<bool> s) => AppRaisedButton(
              loading: loading,
              text: Strings.of(context).labelRegister,
              onPressed: s.data ? () => _authBloc.createUser() : null,
            ),
      );
}
