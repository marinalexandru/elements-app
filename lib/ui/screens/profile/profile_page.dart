import 'package:elements/data/bloc_provider.dart';
import 'package:elements/data/blocs/elements_bloc.dart';
import 'package:elements/data/blocs/steps_bloc.dart';
import 'package:elements/data/models/user_elements.dart';
import 'package:flutter/material.dart';
import 'package:elements/utils/color_theme.dart';
import 'package:elements/utils/strings.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildElementsContainer(context),
          _buildAllTime(context),
        ],
      );

  _buildElementsContainer(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSectionTitle(Strings.of(context).labelAppName),
            Container(height: 25),
            _buildElements(context)
          ],
        ),
      );

  _buildElements(BuildContext context) => StreamBuilder<UserElements>(
        initialData: UserElements(water: 0, earth: 0, fire: 0, wind: 0),
        stream: BlocProvider.of<ElementsBloc>(context).userElements,
        builder: (context, AsyncSnapshot<UserElements> snapshot) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildElementBadge(Strings.of(context).labelWater,
                    "images/water.png", snapshot.data.water),
                _buildElementBadge(Strings.of(context).labelEarth,
                    "images/leaf.png", snapshot.data.earth),
                _buildElementBadge(Strings.of(context).labelFire,
                    "images/fire.png", snapshot.data.fire),
                _buildElementBadge(Strings.of(context).labelWind,
                    "images/wind.png", snapshot.data.wind),
              ],
            ),
      );

  _buildElementBadge(String label, String path, int value) => Column(
        children: [
          Text(label, style: _buildElementBadgeLabelStyle()),
          _buildElementBadgeVerticalSpace(),
          _buildElementBadgeIcon(path),
          _buildElementBadgeVerticalSpace(),
          Text(value.toString(), style: _buildElementBadgeValueStyle())
        ],
      );

  _buildElementBadgeLabelStyle() => TextStyle(
        letterSpacing: 1.5,
        fontSize: 14,
        color: ColorTheme.white,
        fontWeight: FontWeight.bold,
      );

  _buildElementBadgeValueStyle() => TextStyle(
        letterSpacing: 1.3,
        fontSize: 12,
        color: ColorTheme.white,
        fontWeight: FontWeight.w400,
      );

  _buildElementBadgeVerticalSpace() => Container(
        height: 10,
      );

  _buildElementBadgeIcon(String path) => Image(
        width: 28,
        height: 28,
        image: new AssetImage(path),
      );

  _buildAllTime(BuildContext context) => StreamBuilder<int>(
        initialData: 0,
        stream: BlocProvider.of<StepsBloc>(context).userTotalSteps,
        builder: (c, s) => Padding(
              padding: EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(Strings.of(context).labelTotalStats),
                  _buildAllTimeVerticalSpace(),
                  _buildStatEntry(
                    "images/exploration.png",
                    Strings.of(context).labelExploration,
                    "${s.data} ${Strings.of(context).labelSteps}",
                  ),
                  _buildAllTimeVerticalSpace(),
                  _buildStatEntry(
                    "images/element.png",
                    Strings.of(context).labelHarvested,
                    "${(s.data / ElementsBloc.stepsPerElement).round()} ${Strings.of(context).labelElements}",
                  ),
                ],
              ),
            ),
      );

  _buildAllTimeVerticalSpace() => Container(
        height: 20,
      );

  _buildSectionTitle(String title) => Text(
        title,
        style: TextStyle(
          letterSpacing: 3,
          fontSize: 18,
          color: ColorTheme.white,
          fontWeight: FontWeight.w900,
        ),
      );

  _buildStatEntry(String path, String label, String value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: <Widget>[
              _buildStatIcon(path),
              _buildStatEntryHorizontalSpace(),
              Text(label, style: _buildStatEntryLabelStyle()),
            ],
          ),
          Text(value, style: _buildStatEntryValueStyle()),
        ],
      );

  _buildStatIcon(String path) => Image(
        image: AssetImage(path),
        height: 12,
        width: 12,
      );

  _buildStatEntryHorizontalSpace() => Container(
        width: 10,
      );

  _buildStatEntryLabelStyle() => TextStyle(
        letterSpacing: 1.5,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      );

  _buildStatEntryValueStyle() => TextStyle(
        letterSpacing: 1.3,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      );
}
