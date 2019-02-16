import 'dart:math';

import 'package:charts_flutter/flutter.dart';
import 'package:flutter/cupertino.dart';

class MonthChart extends StatelessWidget {
  final List<Series> seriesList;
  final bool animate;

  MonthChart(this.seriesList, {this.animate});

  // EXCLUDE_FROM_GALLERY_DOCS_START
  // This section is excluded from being copied to the gallery.
  // It is used for creating random series data to demonstrate animation in
  // the example app only.
  factory MonthChart.withRandomData() {
    return new MonthChart(_createRandomData());
  }

  /// Create random data.
  static List<Series<LinearSales, num>> _createRandomData() {
    final random = new Random();

    final data = List<int>.generate(30, (i) => i + 1)
        .map((index) => LinearSales(index, random.nextInt(100)))
        .toList();

    return [
      new Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => MaterialPalette.white,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  // EXCLUDE_FROM_GALLERY_DOCS_END

  @override
  Widget build(BuildContext context) {
    return new LineChart(
      seriesList,
      animate: animate,
      domainAxis: NumericAxisSpec(
        renderSpec: GridlineRendererSpec(
          labelStyle: TextStyleSpec(
            color: MaterialPalette.white,
          ),
          lineStyle: LineStyleSpec(
            color: MaterialPalette.transparent,
          ),
        ),
      ),
      primaryMeasureAxis: NumericAxisSpec(
        renderSpec: GridlineRendererSpec(
          labelStyle: TextStyleSpec(
            color: MaterialPalette.transparent,
          ),
          lineStyle: LineStyleSpec(
            color: MaterialPalette.transparent,
          ),
        ),
      ),
    );
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
