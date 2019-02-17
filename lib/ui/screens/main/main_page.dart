import 'package:elements/data/blocs/steps_bloc.dart';
import 'package:flutter/material.dart';
import 'package:elements/ui/screens/harvest/harvest_page.dart';
import 'package:elements/ui/screens/main/widgets/logout_button.dart';
import 'package:elements/ui/screens/profile/profile_page.dart';
import 'package:elements/utils/color_theme.dart';
import 'package:elements/utils/strings.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  StepsBloc stepsBloc;

  @override
  void initState() {
    super.initState();
    stepsBloc = StepsBloc();
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: _buildBackground(),
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Container(
              decoration: _buildBackground(),
              child: _buildMain(),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: _buildFAB(),
          ),
        ),
      );

  _buildBackground() => BoxDecoration(
        color: ColorTheme.dark_blue_101A2C_alphaFF,
      );

  _buildMain() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 1,
            child: _buildHeader(),
          ),
          Expanded(
            flex: 1,
            child: TabBarView(
              children: [
                ProfilePage(),
                HarvestPage(),
              ],
            ),
          ),
        ],
      );

  _buildHeader() => Container(
        decoration: _buildHeaderBackgroundImage(),
        child: Container(
          decoration: _buildHeaderGradientShadow(),
          child: Stack(
            children: [
              Center(child: _buildHeaderTitle()),
              Positioned(child: LogoutButton(), top: 30, right: 0),
              Positioned(child: _buildTabBar(), bottom: 0, left: 0, right: 0)
            ],
          ),
        ),
      );

  _buildHeaderBackgroundImage() => BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/ether.png'),
          fit: BoxFit.cover,
        ),
      );

  _buildHeaderGradientShadow() => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black54, Colors.transparent],
        ),
      );

  _buildHeaderTitle() => Container(
        decoration: _buildHeaderTitleBackground(),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          child: Text(
            Strings.of(context).labelAppName.toUpperCase(),
            style: _buildHeaderTitleStyle(),
          ),
        ),
      );

  _buildHeaderTitleBackground() => BoxDecoration(
      border: Border.all(
        color: ColorTheme.white,
        width: 0.5,
      ),
      color: Colors.black38);

  _buildHeaderTitleStyle() => TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w900,
        letterSpacing: 15,
        fontSize: 30,
      );

  _buildTabBar() => TabBar(
        labelStyle: _buildLabelStyle(),
        labelColor: ColorTheme.white,
        unselectedLabelStyle: _buildUnselectedLabelStyle(),
        tabs: [
          Tab(text: Strings.of(context).labelProfile),
          Tab(text: Strings.of(context).labelHarvest),
        ],
      );

  _buildLabelStyle() => TextStyle(
        letterSpacing: 2.5,
        fontSize: 16,
        fontWeight: FontWeight.w900,
      );

  _buildUnselectedLabelStyle() => TextStyle(
        letterSpacing: 2.5,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  _buildFAB() => FloatingActionButton(
        onPressed: () {
          stepsBloc.connect();
        },
        child: Image(
          image: AssetImage('images/fab.png'),
          width: 48,
          height: 48,
        ),
      );
}
