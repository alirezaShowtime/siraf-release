import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';

class ListDialog extends StatefulWidget {
  @override
  State<ListDialog> createState() => _ListDialog();

  List<Map<String, dynamic>> list = [];
  void Function(Map<String, dynamic>)? onItemTap;
  int? selectedIndex;

  ListDialog({required this.list, this.onItemTap, this.selectedIndex});
}

class _ListDialog extends State<ListDialog> {
  List<Map<String, dynamic>> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.5)),
      backgroundColor: Themes.background,
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Wrap(
          children: [
            Column(
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 200,
                  ),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: widget.list
                        .map<Widget>(
                          (item) => buildListItem(
                            item: item,
                            isLast: widget.list.last == item,
                            onItemTap: widget.onItemTap,
                          ),
                        )
                        .toList(),
                  ),
                ),
                MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  color: Themes.primary,
                  elevation: 0,
                  minWidth: double.infinity,
                  height: 50,
                  child: Text(
                    "تایید",
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 9),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListItem({required Map<String, dynamic> item, bool isLast = false, void Function(Map<String, dynamic>)? onItemTap}) {
    return GestureDetector(
      onTap: () {
        selectedItems.add(item);
        if (onItemTap != null) onItemTap(item);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: isLast ? BorderSide.none : BorderSide(color: Themes.textGrey.withOpacity(0.5), width: 0.7),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        child: Center(
          child: Text(
            item["name"],
            style: TextStyle(
              fontSize: 13,
              color: selectedItems.contains(item) ? Themes.primary : Themes.text,
            ),
          ),
        ),
      ),
    );
  }
}
