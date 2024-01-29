import 'package:flutter/material.dart';
import 'package:mobile_app/api_service.dart';
import 'package:mobile_app/requests/severity_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Import the syncfusion_flutter_charts package

class DailyHeathChart extends StatefulWidget {
  const DailyHeathChart({super.key, required this.apiService});
  final ApiService apiService;

  @override
  State<DailyHeathChart> createState() => _DailyHealthChart();
}

class _DailyHealthChart extends State<DailyHeathChart> {
  Map<String, dynamic>? severityData;
  late SeverityService severityService;

  @override
  void initState() {
    severityService = SeverityService(widget.apiService);
    super.initState();
    _loadSeverity();
  }

  Future<void> _loadSeverity() async {
    try {
      final Map<String, dynamic> data = await severityService.getSeverity();
      setState(() {
        severityData = data;
      });
      print(severityData?['dailyHealth'][0]['severity']);
    } catch (error) {
      print('Error loading chatbot response: $error');
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Severity Chart'),
      ),
      body: severityData != null
          ? _buildChart()
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _buildChart() {
    List<ChartData> chartData = [];
    for (int i = 0; i < 7; i++) {
      chartData.add(
        ChartData(
          day: i + 1,
          severity: (severityData?['dailyHealth'][i]['severity'] ?? 0).toDouble(),
        ),
      );
    }

    return SfCartesianChart(
      primaryXAxis: NumericAxis(
        title: AxisTitle(text: 'Days'),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Severity'),
      ),
      series: <CartesianSeries<ChartData, int>>[
        LineSeries<ChartData, int>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.day,
          yValueMapper: (ChartData data, _) => data.severity,
          name: 'Severity',
        ),
      ],
    );
  }
}

class ChartData {
  ChartData({required this.day, required this.severity});

  final int day;
  final double severity;
}