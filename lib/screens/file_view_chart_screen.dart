import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/file_view_chart_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/file_view.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/simple_app_bar.dart';
import 'package:siraf3/widgets/try_again.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FileViewChartScreen extends StatefulWidget {
  int id;
  String fileTitle;

  FileViewChartScreen({required this.id, required this.fileTitle, Key? key}) : super(key: key);

  @override
  State<FileViewChartScreen> createState() => _FileViewChartScreenState();
}

class _FileViewChartScreenState extends State<FileViewChartScreen> {
  FVCBloc bloc = FVCBloc();

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FVCBloc>(
      create: (context) => bloc,
      child: Scaffold(
        appBar: SimpleAppBar(
          titleText: "آمار بازدید",
        ),
        body: BlocBuilder<FVCBloc, FVCState>(
          builder: _mainBlocBuilder,
        ),
      ),
    );
  }

  _loadData() {
    bloc.add(FVCEvent(id: widget.id));
  }

  Widget _mainBlocBuilder(BuildContext context, FVCState state) {
    print(state);

    if (state is FVCInitState) {
      return Container();
    }

    if (state is FVCLoadingState) {
      return Center(
        child: Loading(),
      );
    }

    if (state is FVCErrorState) {
      String? message;

      if (jDecode(state.response.body)['message'] is String) {
        message = jDecode(state.response.body)['message'];
      }

      return Center(
        child: TryAgain(
          onPressed: _loadData,
          message: message,
        ),
      );
    }

    state = FVCLoadedState(views: (state as FVCLoadedState).views);

    return _buildChart(state.views);
  }

  Widget _buildChart(List<FileView> views) {
    var minYAxis = 0;
    if (views.isNotEmpty) {
      var data = views;
      data.sort((a, b) => a.count!.compareTo(b.count!));
      if (data.first.count! > 0) {
        minYAxis = data.first.count! - 1;
      } else {
        minYAxis = data.first.count!;
      }
    }
    return Container(
      height: 450,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: SfCartesianChart(
        borderColor: App.theme.backgroundColor,
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          labelStyle: TextStyle(
            fontFamily: "IranSansMedium",
            color: App.theme.textTheme.bodyLarge?.color,
          ),
        ),
        primaryYAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          labelStyle: TextStyle(
            fontFamily: "IranSansMedium",
            color: App.theme.textTheme.bodyLarge?.color,
          ),
          minimum: minYAxis.toDouble(),
        ),
        title: ChartTitle(
          text: 'آمار بازدید فایل ${widget.fileTitle}',
          textStyle: TextStyle(
            color: App.theme.textTheme.bodyLarge?.color,
            fontSize: 11,
            fontFamily: "IranSansMedium",
          ),
          alignment: ChartAlignment.far,
        ),
        trackballBehavior: TrackballBehavior(enable: true),
        legend: Legend(isVisible: false),
        tooltipBehavior: TooltipBehavior(
          enable: false,
          textStyle: TextStyle(fontFamily: "IranSansMedium"),
        ),
        series: <StackedLineSeries<FileView, String>>[
          StackedLineSeries<FileView, String>(
            dataSource: views,
            xValueMapper: (FileView fileView, _) => fileView.date,
            yValueMapper: (FileView fileView, _) => fileView.count,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(
                fontFamily: "IranSansMedium",
                color: App.theme.textTheme.bodyLarge?.color,
              ),
            ),
            markerSettings: MarkerSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}
