import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:elements/data/bloc_provider.dart';
import 'package:elements/data/blocs/auth_bloc.dart';
import 'package:elements/ui/screens/splash/splash_page.dart';
import 'package:elements/utils/color_theme.dart';

void main() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => CommonProviders(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // Define the default Brightness and Colors
            brightness: Brightness.dark,
            errorColor: ColorTheme.ember,
            primaryColor: ColorTheme.white,
            accentColor: Colors.white,
            buttonColor: ColorTheme.white,
            textSelectionColor: ColorTheme.white_alpha38,
            textSelectionHandleColor: ColorTheme.white,
            cursorColor: ColorTheme.white,
            dialogBackgroundColor: ColorTheme.white,
          ),
          home: SplashPage(),
        ),
      );
}

class CommonProviders extends StatelessWidget {
  final Widget child;

  CommonProviders({this.child});

  @override
  Widget build(BuildContext context) => BlocProvider<AuthBloc>(
        bloc: AuthBloc(),
        child: child,
      );
}
