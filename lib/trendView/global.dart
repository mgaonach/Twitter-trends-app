import 'package:charts_flutter/flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twitter_trends/apiAccess.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Global extends StatelessWidget {
  final List<Trend> trends;

  Global({this.trends});

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).accentColor;
    var c = new charts.Color(
        r: color.red, g: color.green, b: color.blue, a: color.alpha);
    return SafeArea(
      child: buildChart(trends, c),
    );
  }

  Widget buildChart(List<Trend> trends, charts.Color color) {
    var chart = BarChart(
      buildSeries(trends, color),
      animate: true,
      vertical: false,
      barRendererDecorator: BarLabelDecorator<String>(),
      //domainAxis: OrdinalAxisSpec(renderSpec: NoneRenderSpec()),
    );

    var chartWidget = new Padding(
      padding: new EdgeInsets.all(20.0),
      child: new SizedBox(
        //height: 200.0,
        child: chart,
      ),
    );

    return chartWidget;
  }

  List<Series<Trend, String>> buildSeries(
      List<Trend> trends, charts.Color color) {
    return [
      Series(
        id: 'trends',
        data: trends,
        domainFn: (Trend t, _) => "${trends.indexOf(t) + 1}",
        measureFn: (Trend t, _) => t.volume,
        labelAccessorFn: (Trend t, _) => "${t.name} - ${NumberFormat.compact().format(t.volume)}",
        colorFn: (Trend t, _) => color,
      )
    ];
  }
}
