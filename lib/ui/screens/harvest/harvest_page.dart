import 'package:flutter/material.dart';
import 'package:elements/ui/screens/harvest/widgets/week_chart.dart';
import 'package:elements/utils/color_theme.dart';
import 'package:elements/utils/strings.dart';

class HarvestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildWeekChart(context),
          _buildElementsContainer(context),
        ],
      );

  _buildWeekChart(BuildContext context) => Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(Strings.of(context).labelThisWeek),
            Container(height: 10),
            Container(height: 100, child: WeekChart.withRandomData()),
          ],
        ),
      );

  _buildElementsContainer(BuildContext context) => Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(Strings.of(context).labelHarvestedElements),
            Container(height: 20),
            _buildElementRow1(context),
            Container(height: 10),
            _buildElementRow2(context),
          ],
        ),
      );

  _buildElementRow1(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _buildElement(
                Strings.of(context).labelWater, "images/water.png", 100),
          ),
          Container(width: 10),
          Expanded(
            child: _buildElement(
                Strings.of(context).labelEarth, "images/leaf.png", 80),
          ),
        ],
      );

  _buildElementRow2(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _buildElement(
                Strings.of(context).labelFire, "images/fire.png", 90),
          ),
          Container(width: 10),
          Expanded(
            child: _buildElement(
                Strings.of(context).labelWind, "images/wind.png", 75),
          ),
        ],
      );

  _buildSectionTitle(String title) => Text(
        title,
        style: TextStyle(
          letterSpacing: 2.5,
          fontSize: 18,
          color: ColorTheme.white,
          fontWeight: FontWeight.w900,
        ),
      );

  _buildElement(String title, String path, int value) => Container(
        decoration: _buildElementBackground(),
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Row(
            children: [
              _buildElementIcon(path),
              Container(width: 10),
              Text(title, style: _buildElementLabelStyle()),
              Expanded(
                child: Text(
                  value.toString(),
                  textAlign: TextAlign.end,
                  style: _buildElementLabelValue(),
                ),
              )
            ],
          ),
        ),
      );

  _buildElementBackground() => BoxDecoration(
        border: Border.all(color: ColorTheme.white, width: 0.5),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      );

  _buildElementIcon(String path) => Image(
        image: AssetImage(path),
        width: 23,
        height: 23,
      );

  _buildElementLabelStyle() => TextStyle(
        letterSpacing: 1.5,
        fontSize: 13,
        color: ColorTheme.white,
        fontWeight: FontWeight.bold,
      );

  _buildElementLabelValue() => TextStyle(
        letterSpacing: 1.2,
        fontSize: 11,
        color: ColorTheme.white,
        fontWeight: FontWeight.w400,
      );
}
