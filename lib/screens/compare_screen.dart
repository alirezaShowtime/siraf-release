import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/compare_bloc.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/models/file_compare.dart';
import 'package:siraf3/models/file_compare.dart' as fc;
import 'package:siraf3/screens/file_screen.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/try_again.dart';
import 'package:flutter/material.dart' as m;

class CompareScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CompareScreen();

  List<File> files;

  CompareScreen({required this.files});
}

class _CompareScreen extends State<CompareScreen> {
  CompareBloc compareBloc = CompareBloc();

  List<FileCompare> files = [];

  @override
  void initState() {
    super.initState();

    requestComparision();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => compareBloc,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: MyBackButton(),
          title: AppBarTitle("مقایسه"),
        ),
        body: BlocBuilder<CompareBloc, CompareState>(builder: _compareBuilder),
      ),
    );
  }

  List<String> getPropertiesName(List<FileCompare> files) {
    List<fc.Property> largestProperties = [];

    files.forEach((file) {
      if (file.property.isFill()) {
        file.property!.forEach((prop) {
          if (prop.name.isFill() && !largestProperties.any((e) => e.name!.trim() == prop.name!.trim())) {
            largestProperties.add(prop);
          }
        });
      }
    });

    largestProperties.sort((a, b) => (a.section ?? 0).compareTo(b.section ?? 0));

    return largestProperties.where((e) => e.name != null).map((e) => e.name!).toList();
  }

  Widget _compareBuilder(BuildContext context, CompareState state) {
    if (state is CompareInitState) return Container();
    if (state is CompareLoadingState) return Center(child: Loading());

    if (state is CompareErrorState) {
      var message = jDecode(state.response.body)['message'] as String?;

      return Center(
        child: TryAgain(
          message: message,
          onPressed: requestComparision,
        ),
      );
    }

    if (state is CompareLoadedState) {
      files = state.files;
      var propertiesName = getPropertiesName(files);

      return Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: _CompareItem(propertiesName: propertiesName),
                  ),
                  Row(
                    children: <Widget>[
                          SizedBox(width: 70),
                        ] +
                        files
                            .map<Widget>(
                              (e) => _CompareItem(
                                file: e,
                                onClickCloseButton: () {
                                  if (files.length <= 2) {
                                    notify("برای مقاسیه حداقل 2 فایل لازم است.");
                                    return;
                                  }
                                  files.remove(e);
                                  setState(() {});
                                },
                                propertiesName: propertiesName,
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Container();
  }

  requestComparision() {
    compareBloc.add(CompareEvent(files: widget.files));
  }
}

class _CompareItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CompareItemState();

  List<String>? propertiesName;
  FileCompare? file;
  Function? onClickCloseButton;

  _CompareItem({this.file, this.propertiesName, this.onClickCloseButton});
}

class _CompareItemState extends State<_CompareItem> {
  List<Widget> _widgets = [];

  @override
  Widget build(BuildContext context) {
    if (widget.propertiesName != null && widget.file == null) {
      return Container(
        width: 70,
        margin: EdgeInsets.only(top: 198.3, right: 5),
        padding: EdgeInsets.only(top: 17),
        decoration: BoxDecoration(
          color: App.theme.backgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.propertiesName!.map<Widget>((propertyName) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 6),
              child: Text(
                propertyName,
                style: TextStyle(
                  fontFamily: "IranSansBold",
                  fontSize: 12,
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    return Container(
      width: widget.propertiesName.isNotNullOrEmpty() && widget.file == null ? null : 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _propertyWidgets(widget.file!, widget.propertiesName!),
      ),
    );
  }

  List<Widget> _propertyWidgets(FileCompare file, List<String> names) {
    file.property!.sort((a, b) => (a.section ?? 0).compareTo(b.section ?? 0));
    // if (_widgets.isNotEmpty) return _widgets;
    _widgets.clear();
    _widgets.add(
      Align(alignment: Alignment.center, child: imageAndNameWidget(file.file!)),
    );

    names.forEach((name) {
      Widget widget;

      if (file.property!.any((element) => element.name == name)) {
        var property = file.property!.firstWhere((element) => element.name == name);
        widget = Padding(
          padding: const EdgeInsets.symmetric(vertical: 7.5),
          child: Text(
            property.value ?? '-',
            style: TextStyle(
              color: App.theme.tooltipTheme.textStyle?.color,
              fontSize: 12,
            ),
          ),
        );
      } else {
        widget = Padding(
          padding: const EdgeInsets.symmetric(vertical: 7.5),
          child: Text(
            '-',
            style: TextStyle(
              color: App.theme.tooltipTheme.textStyle?.color,
              fontSize: 12,
            ),
          ),
        );
      }

      _widgets.add(Stack(
        children: [
          Container(
            width: 70,
            padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 6),
            child: Text(
              name,
              style: TextStyle(
                fontFamily: "IranSansBold",
                fontSize: 12,
                color: App.theme.backgroundColor,
              ),
            ),
          ),
          Align(alignment: Alignment.center, child: widget),
        ],
      ));
    });

    return _widgets;
  }

  Widget imageAndNameWidget(File file) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10, top: 15),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                if (widget.onClickCloseButton != null) {
                  widget.onClickCloseButton!();
                }
              },
              borderRadius: BorderRadius.circular(10),
              child: icon(
                Icons.close_rounded,
                size: 24,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => FileScreen(id: file.id!)));
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: m.Image(
                      image: NetworkImage((file.images != null && file.images!.isNotEmpty) ? file.images!.first.path ?? "" : ""),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => m.Image(
                        image: AssetImage(IMAGE_NOT_AVAILABLE),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 8),
                    alignment: Alignment.center,
                    child: Text(
                      file.name != null ? file.name! + "\n\n" : "\n\n",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: "IranSansBold",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
