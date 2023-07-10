import 'package:flutter/material.dart';

class PaginationLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.grey.shade200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 15,
            height: 15,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          SizedBox(width: 10),
          Text(
            "در حال بارگذاری موارد بیشتر",
            style: TextStyle(
              fontSize: 10,
              fontFamily: "IranSansBold",
            ),
          ),
        ],
      ),
    );
  }
}
