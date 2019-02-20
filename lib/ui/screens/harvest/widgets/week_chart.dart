import 'dart:math';

import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class WeekChart extends StatelessWidget {
  final List<Series> seriesList;
  final bool animate;

  WeekChart(this.seriesList, {this.animate});

  // EXCLUDE_FROM_GALLERY_DOCS_START
  // This section is excluded from being copied to the gallery.
  // It is used for creating random series data to demonstrate animation in
  // the example app only.
  factory WeekChart.withWeekData(List<int> list) {
    return WeekChart(_createWeekData(list));
  }

  /// Create random data.
  static List<Series<OrdinalSteps, String>> _createWeekData(List<int> list) {
//    final data =
//    list.map((weekSteps) => OrdinalSteps("day", weekSteps)).toList();


    final data = [
      new OrdinalSteps('MON', list[0]),
      new OrdinalSteps('TUE', list[1]),
      new OrdinalSteps('WED', list[2]),
      new OrdinalSteps('THU', list[3]),
      new OrdinalSteps('FRI', list[4]),
      new OrdinalSteps('SAT', list[5]),
      new OrdinalSteps('SUN', list[6]),
    ];

    return [
      new Series<OrdinalSteps, String>(
        id: 'Week activity',
        colorFn: (_, __) => MaterialPalette.white,
        domainFn: (OrdinalSteps sales, _) => sales.day,
        measureFn: (OrdinalSteps sales, _) => sales.active,
        data: data,
      )
    ];
  }

  // EXCLUDE_FROM_GALLERY_DOCS_END

  @override
  Widget build(BuildContext context) {
    return BarChart(
      seriesList,
      animate: animate,
      primaryMeasureAxis: NumericAxisSpec(
        renderSpec: GridlineRendererSpec(
          // Tick and Label styling here.
          labelStyle: TextStyleSpec(
            color: MaterialPalette.white,
          ),

          // Change the line colors to match text color.
          lineStyle: LineStyleSpec(color: MaterialPalette.transparent),
        ),
      ),
      domainAxis: OrdinalAxisSpec(
        renderSpec: SmallTickRendererSpec(
          // Tick and Label styling here.
          labelStyle: TextStyleSpec(color: MaterialPalette.white),
          // Change the line colors to match text color.
          lineStyle: LineStyleSpec(color: MaterialPalette.transparent),
        ),
      ),
    );
  }
}

/// Sample ordinal data type.
class OrdinalSteps {
  final String day;
  final int active;

  OrdinalSteps(this.day, this.active);
}
