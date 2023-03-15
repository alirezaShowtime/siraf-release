import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/screens/file_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/helpers.dart';

class CompareScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CompareScreen();

  List<File> files;

  CompareScreen({required this.files});
}

class _CompareScreen extends State<CompareScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: MyBackButton(),
        title: AppBarTitle("مقایسه"),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.files.length + 1,
                  itemBuilder: (BuildContext context, int i) {
                    if (i == 0) return SizedBox(width: 40);
                    return _CompareItem(
                      file: widget.files[i - 1],
                      onClickCloseButton: () {
                        if (widget.files.length <= 2) {
                          notify("برای مقاسیه حداقل 2 فایل لازم است.");
                          return;
                        }
                        widget.files.remove(widget.files[i - 1]);
                        setState(() {});
                      },
                    );
                  },
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: _CompareItem(propertiesName: getPropertiesName()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> getPropertiesName() {
    List<String> largestPropertiesName = [];

    widget.files.forEach((file) {
      if ((file.propertys?.length ?? 0) > largestPropertiesName.length) {
        largestPropertiesName =
            file.propertys!.map((e) => e.name ?? "").toList();
      }
    });

    return largestPropertiesName;
  }
}

class _CompareItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CompareItemState();

  List<String>? propertiesName;
  File? file;
  Function? onClickCloseButton;

  _CompareItem({this.file, this.propertiesName, this.onClickCloseButton});
}

class _CompareItemState extends State<_CompareItem> {
  List<Widget> _widgets = [];
  Widget? _propertyColumns;

  @override
  Widget build(BuildContext context) {
    if (widget.propertiesName != null) {
      return _getPropertyColumns();
    }

    return Container(
      width: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _propertyWidgets(),
      ),
    );
  }

  List<Widget> _propertyWidgets() {
    // if (_widgets.isNotEmpty) return _widgets;
    _widgets.clear();
    _widgets.add(
      Align(
          alignment: Alignment.center, child: imageAndNameWidget(widget.file!)),
    );

    _widgets.addAll(widget.file!.propertys!.map((property) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.5),
        child: Text(
          property.value ?? '-',
          style: TextStyle(
            color: App.theme.tooltipTheme.textStyle?.color,
            fontSize: 12,
          ),
        ),
      );
    }));

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
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => FileScreen(id: file.id!)));
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      image: NetworkImage(
                          (file.images != null && file.images!.isNotEmpty)
                              ? file.images!.first.path ?? ""
                              : ""),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image(
                        image: AssetImage(
                            IMAGE_NOT_AVAILABLE),
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
                        fontWeight: FontWeight.bold,
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

  Widget _getPropertyColumns() {
    // if (_propertyColumns != null) return _propertyColumns!;

    _propertyColumns = Container(
      width: 70,
      margin: EdgeInsets.only(top: 198.3),
      padding: EdgeInsets.only(top: 17),
      decoration: BoxDecoration(
        color: App.theme.backgroundColor,
      ),
      child: Column(
        children: widget.propertiesName!.map((propertyName) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 6),
            child: Text(
              propertyName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          );
        }).toList(),
      ),
    );

    return _propertyColumns!;
  }
}
