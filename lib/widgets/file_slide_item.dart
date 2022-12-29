import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/custom_slider.dart';

class FileSlideItem extends StatefulWidget {
  const FileSlideItem({super.key});

  @override
  State<FileSlideItem> createState() => _FileSlideItemState();
}

class _FileSlideItemState extends State<FileSlideItem> {
  String description =
      "ولنجک ۹۸متر دو خواب نوساز طبقه ۴ پنجرها تمامن قدی به هیچ عنوان نورگیری پاسیو ندارد لابی ۲لاین آسانسور پارکینگ انباری ۱۰٪ از مبلغ کل برای سند کسر میگردد";

  String summary =
      "ولنجک ۹۸متر دو خواب نوساز طبقه ۴ پنجرها تمامن قدی به هیچ عنوان نورگیری پاسیو...";

  bool showSummary = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CarouselSliderCustom(
                images: [
                  "https://s101.divarcdn.com/static/pictures/1672039920/wYp2EofF.jpg",
                  "https://s101.divarcdn.com/static/pictures/1672039920/wYp2EofF.1.jpg",
                  "https://s101.divarcdn.com/static/pictures/1672039920/wYp2EofF.2.jpg",
                ],
                height: 250,
                indicatorsCenterAlign: true,
                viewportFraction: 1.0,
                itemMargin: EdgeInsets.only(bottom: 15),
                indicatorPosition:
                    EdgeInsets.only(left: 0, right: 0, bottom: 0),
                itemBorderRadius: BorderRadius.zero,
                imageFit: BoxFit.cover,
                indicatorSelectedColor: Themes.blue,
                indicatorColor: Colors.grey,
              ),
              Positioned(
                bottom: 22.5,
                right: 7.5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff6c6c6c).withOpacity(0.8),
                  ),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "300,000,000 ودیعه",
                        style: TextStyle(
                          color: Themes.textLight,
                          fontFamily: "BYekan",
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "4,000,000 اجاره",
                        style: TextStyle(
                          color: Themes.textLight,
                          fontFamily: "BYekan",
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Image(
                      image: AssetImage("assets/images/ic_save.png"),
                      width: 24,
                      height: 24,
                      color: Themes.primary,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "اجاره ای | آپارتمان 85 متری، شهرک اکباتان",
                        style: TextStyle(
                          color: Themes.text,
                          fontFamily: "BYekan",
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "10 دقیقه پیش | تهران",
                        style: TextStyle(
                          color: Themes.textGrey,
                          fontFamily: "BYekan",
                          fontSize: 11,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: Image(
                  image: AssetImage("assets/images/ic_share.png"),
                  width: 16,
                  height: 16,
                  color: Themes.primary,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 12),
            child: Row(
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
          ),
          Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: showSummary ? summary : description,
                      style: TextStyle(
                        color: Themes.primary,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'BYekan',
                      ),
                    ),
                    TextSpan(
                        text: showSummary ? ' توضیحات بیشتر' : ' توضیحات کمتر',
                        style: TextStyle(
                          color: Themes.blue,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'BYekan',
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("tappped");
                            setState(() {
                              showSummary = !showSummary;
                            });
                          }),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
