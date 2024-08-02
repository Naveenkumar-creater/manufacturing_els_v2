import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DoughnutChart extends StatefulWidget {
  const DoughnutChart({super.key});

  @override
  State<DoughnutChart> createState() => _DoughnutChartState();
}

class _DoughnutChartState extends State<DoughnutChart> {
  late List<ProcessTargetData> _chartData;
  late TooltipBehavior _toolTipBehavior;
  @override
  void initState() {
    _chartData = getChartData();
    _toolTipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      title: ChartTitle(text: 'Target in quantity'),
      legend:
          Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      tooltipBehavior: _toolTipBehavior,
      series: <CircularSeries>[
        DoughnutSeries<ProcessTargetData, String>(
            enableTooltip: true,
            dataSource: _chartData,
            xValueMapper: (ProcessTargetData data, _) => data.processName,
            yValueMapper: (ProcessTargetData data, _) => data.quantity,
            dataLabelSettings: DataLabelSettings(isVisible: true))
      ],
    );
  }

  List<ProcessTargetData> getChartData() {
    final List<ProcessTargetData> chartData = [
      ProcessTargetData('process1', 20),
      ProcessTargetData('process2', 50),
      ProcessTargetData('process3', 80),
      ProcessTargetData('process4', 30)
    ];
    return chartData;
  }
}

class ProcessTargetData {
  final String processName;
  final int quantity;

  ProcessTargetData(this.processName, this.quantity);
}
