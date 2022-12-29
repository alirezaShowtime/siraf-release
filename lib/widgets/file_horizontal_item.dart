import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';

class FileHorizontalItem extends StatefulWidget {
  const FileHorizontalItem({super.key});

  @override
  State<FileHorizontalItem> createState() => _FileHorizontalItemState();
}

class _FileHorizontalItemState extends State<FileHorizontalItem> {
  @override
  Widget build(BuildContext context) {
    double imageSize = (MediaQuery.of(context).size.width - 20) / 3.5;
    if (imageSize > 140) imageSize = 140;
    return Container(
      decoration: BoxDecoration(color: Themes.background, boxShadow: [
        BoxShadow(
          color: Themes.background2,
          blurRadius: 2,
          spreadRadius: 2,
          offset: Offset(0, -3),
        ),
      ]),
      padding: EdgeInsets.all(10),
      height: imageSize + 20,
      constraints: BoxConstraints(maxHeight: 160),
      width: double.infinity,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: AssetImage(
                "assets/images/1.jpg",
              ),
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '300,000,000 ودیعه',
                          style: TextStyle(
                            color: Themes.text,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'BYekan',
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          '4,000,000 کرایه',
                          style: TextStyle(
                            color: Themes.text,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'BYekan',
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '10 دقیقه پیش | تهران',
                      style: TextStyle(
                        color: Themes.text,
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'BYekan',
                      ),
                    ),
                  ],
                ),
                Text(
                  'اجاره ای | آپارتمان 145 متری در آجودانیه',
                  style: TextStyle(
                    color: Themes.primary,
                    fontSize: 13.5,
                    fontFamily: 'BYekan',
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '',
                      style: TextStyle(
                        color: Themes.text,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'BYekan',
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '145 متــری',
                          style: TextStyle(
                            color: Themes.primary,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'BYekan',
                          ),
                        ),
                        Text(
                          '2 خــوابه',
                          style: TextStyle(
                            color: Themes.primary,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'BYekan',
                          ),
                        ),
                        Text(
                          '2 آسانسور',
                          style: TextStyle(
                            color: Themes.primary,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'BYekan',
                          ),
                        ),
                        Text(
                          'با پارکـینگ',
                          style: TextStyle(
                            color: Themes.primary,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'BYekan',
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
