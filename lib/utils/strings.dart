import 'package:flutter/cupertino.dart';

/// This can be extended in a fully featured internationalization class.
/// https://flutter.io/docs/development/accessibility-and-localization/internationalization
class Strings {
  String get labelLogin => 'LOGIN';

  String get labelEmail => 'Email';

  String get labelEmailHint => 'enter your email...';

  String get labelPassword => 'Password';

  String get labelPasswordHint => 'enter your password...';

  String get labelNoAccount => "Don't have an account?\nCreate one ";

  String get labelHere => "here";

  String get labelRepeatPassword => 'Repeat password';

  String get labelRepeatPasswordHint => 'please repeat your password...';

  String get labelRegister => 'REGISTER';

  String get labelAlreadyHave => 'Already have? ';

  String get labelSignIn => 'Sign In';

  String get errorInvalidEmail => 'Invalid email.';

  String get errorPasswordLength => 'Password must have at least 6 chars.';

  String get errorPasswordMatch => 'Password does not match.';

  String get errorUserAlreadyRegistered => 'User already registered.';

  String get errorGeneralError => 'A processing error has occured.';

  String get errorInvalidCredentials => 'User credentials are not valid.';

  String get errorAnonymousSignInNotAllowed => 'Anonymous Sign In Not Allowed.';

  String get errorWeakPassword => 'Password is weak.';

  String get labelLoading => 'Please wait...';

  String get labelSuccessLogin => 'Successfully logged in.';

  String get labelSuccessRegister => 'Successfully registered.';

  String get labelAppName => 'Elements';

  String get labelSubAppName => 'Harvest App';

  String get labelOk => 'Ok';

  String get labelCancel => 'Cancel';

  String get labelErrorPrefix => 'Error: ';

  String get labelProfile => 'Profile';

  String get labelHarvest => 'Harvest';

  String get labelEarth => 'Earth';

  String get labelWater => 'Water';

  String get labelFire => 'Fire';

  String get labelWind => 'Wind';

  String get labelTotalStats => 'Total Stats';

  String get labelExploration => 'Exploration';

  String get labelHarvested => 'Harvested';

  String get labelSteps => 'steps';

  String get labelElements => 'elements';

  String get labelThisWeek => 'This Week';

  String get labelHarvestedElements => 'Harvested Elements';

  String get labelLogoutQuestion => 'Are you sure you want to logout?';

  static Strings of(BuildContext context) {
    return Strings();
  }
}
