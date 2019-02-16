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
  factory WeekChart.withRandomData() {
    return WeekChart(_createRandomData());
  }

  /// Create random data.
  static List<Series<OrdinalSales, String>> _createRandomData() {
    final random = new Random();

    final data = [
      new OrdinalSales('MON', random.nextInt(10000)),
      new OrdinalSales('TUE', random.nextInt(10000)),
      new OrdinalSales('WED', random.nextInt(10000)),
      new OrdinalSales('THU', random.nextInt(10000)),
      new OrdinalSales('FRI', random.nextInt(10000)),
      new OrdinalSales('SAT', random.nextInt(10000)),
      new OrdinalSales('SUN', random.nextInt(10000)),
    ];

    return [
      new Series<OrdinalSales, String>(
        id: 'Week activity',
        colorFn: (_, __) => MaterialPalette.white,
        domainFn: (OrdinalSales sales, _) => sales.day,
        measureFn: (OrdinalSales sales, _) => sales.active,
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
class OrdinalSales {
  final String day;
  final int active;

  OrdinalSales(this.day, this.active);
}
