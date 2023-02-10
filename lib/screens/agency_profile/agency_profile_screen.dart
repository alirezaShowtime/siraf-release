import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/file_horizontal_item.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/my_text_button.dart';
import 'package:siraf3/widgets/my_text_icon_button.dart';
import 'package:siraf3/widgets/static_star.dart';
import 'package:siraf3/widgets/text_field_2.dart';

class AgencyProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AgencyProfileScreen();
}

class _AgencyProfileScreen extends State<AgencyProfileScreen> with SingleTickerProviderStateMixin {
  List<File> list = [
    File(
      id: 342,
      name: "hello owlrs",
      description: "fdslfdsfkp[dk dsolpfdjs fiod",
      city: "تهران",
      publishedAgo: "یک هفته پیش",
      propertys: [
        Property(
          name: "heloweds",
          value: "fkds",
          weightList: 1,
          list: true,
        ),
        Property(
          name: "heloweds",
          value: "fkds",
          weightList: 2,
          list: true,
        ),
        Property(
          name: "heloweds",
          value: "fkds",
          weightList: 3,
          list: true,
        ),
      ],
      fullCategory: FullCategory(
        fullCategory: "fdskofk ",
        name: "dfsofijdsf ",
        id: 1,
        image: "fdjspofkdspofk dsf",
      ),
      favorite: true,
      // images: [
      //   Images(
      //       idm : "",
      //       createDatem : "",
      //       pathm : "",
      //       statusm : "",
      //       weightm : "",
      //       namem : "",
      //       fileIdm : "",
      //   ),
      // ],
    ),
  ];

  List<Map<String, dynamic>> comments = [
    {
      "comment": "hello world",
      "star": 3.5,
      "date": "1401/05/19",
      "likes": 12,
      "dislike": 2,
      "user": {
        "username": "alireza",
        "profileImage": "kdiofksdpofkds jfoidkf fd",
      },
      "answers": [
        {
          "comment": "hello world",
          "star": 3.5,
          "date": "1401/05/19",
          "likes": 12,
          "dislike": 2,
          "user": {
            "username": "alireza",
            "profileImage": "kdiofksdpofkds jfoidkf fd",
          },
        },
        {
          "comment": "hello world",
          "star": 3.5,
          "date": "1401/05/19",
          "likes": 12,
          "dislike": 2,
          "user": {
            "username": "alireza",
            "profileImage": "kdiofksdpofkds jfoidkf fd",
          },
        },
      ],
    },
    {
      "comment": "hello world",
      "star": 3.5,
      "date": "1401/05/19",
      "likes": 12,
      "dislike": 2,
      "user": {
        "username": "alireza",
        "profileImage": "kdiofksdpofkds jfoidkf fd",
      },
      "answers": [
        {
          "comment": "hello world",
          "star": 3.5,
          "date": "1401/05/19",
          "likes": 12,
          "dislike": 2,
          "user": {
            "username": "alireza",
            "profileImage": "kdiofksdpofkds jfoidkf fd",
          },
        },
        {
          "comment": "hello world",
          "star": 3.5,
          "date": "1401/05/19",
          "likes": 12,
          "dislike": 2,
          "user": {
            "username": "alireza",
            "profileImage": "kdiofksdpofkds jfoidkf fd",
          },
        },
      ],
    },
    {
      "comment": "hello world",
      "star": 3.5,
      "date": "1401/05/19",
      "likes": 12,
      "dislike": 2,
      "user": {
        "username": "alireza",
        "profileImage": "kdiofksdpofkds jfoidkf fd",
      },
      "answers": [
        {
          "comment": "hello world",
          "star": 3.5,
          "date": "1401/05/19",
          "likes": 12,
          "dislike": 2,
          "user": {
            "username": "alireza",
            "profileImage": "kdiofksdpofkds jfoidkf fd",
          },
        },
        {
          "comment": "hello world",
          "star": 3.5,
          "date": "1401/05/19",
          "likes": 12,
          "dislike": 2,
          "user": {
            "username": "alireza",
            "profileImage": "kdiofksdpofkds jfoidkf fd",
          },
        },
      ],
    },
    {
      "comment": "hello world",
      "star": 3.5,
      "date": "1401/05/19",
      "likes": 12,
      "dislike": 2,
      "user": {
        "username": "alireza",
        "profileImage": "kdiofksdpofkds jfoidkf fd",
      },
      "answers": [
        {
          "comment": "hello world",
          "star": 3.5,
          "date": "1401/05/19",
          "likes": 12,
          "dislike": 2,
          "user": {
            "username": "alireza",
            "profileImage": "kdiofksdpofkds jfoidkf fd",
          },
        },
        {
          "comment": "hello world",
          "star": 3.5,
          "date": "1401/05/19",
          "likes": 12,
          "dislike": 2,
          "user": {
            "username": "alireza",
            "profileImage": "kdiofksdpofkds jfoidkf fd",
          },
        },
      ],
    },
  ];

  bool showComment = false;

  bool moreDetail = false;

  // bool moreDetail = false;
  bool showCommentWidget = false;

  late AnimationController _collopsController;
  late Animation<double> _collopsAnimation;

  String? comment;
  double? rating;

  @override
  void initState() {
    super.initState();

    _collopsController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _collopsAnimation = CurvedAnimation(parent: _collopsController, curve: Curves.fastOutSlowIn);

    _collopsController.addListener(_collopsControllerListener);
  }

  @override
  void dispose() {
    super.dispose();
    _collopsController.removeListener(_collopsControllerListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Container(
              height: 170,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Avatar(size: 80, imagePath: "https://blog.logrocket.com/wp-content/uploads/2021/04/10-best-Tailwind-CSS-component-and-template-collections.png"),
                      Container(
                        padding: const EdgeInsets.only(left: 2),
                        decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.grey.shade200, width: 1))),
                        child: Column(
                          children: [
                            Text(
                              "املاک برج",
                              style: TextStyle(
                                color: Themes.text,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "93405355345",
                              style: TextStyle(
                                color: Themes.text,
                                fontSize: 11,
                              ),
                            ),
                            StaticStar(rating: 4.5),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                card(title: "فروشی", value: "10", onTap: () {}),
                                card(title: "اجاره ای", value: "75", onTap: () {}),
                                card(title: "ساخت و ساز", value: "23", onTap: () {}),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                "ds;ofdskj dolspfk dkdofdks oidmnsfk dnf dosmjfoidns d[sk fldpofdspofmks dpolfkdms dms,fp[doskjf ods,fkdpsnf dpsfdms fdskmofds",
                                maxLines: 2,
                                style: TextStyle(color: Themes.textGrey, fontSize: 11),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: viewMoreDetail,
                                    child: Text(
                                      moreDetail ? "کمتر" : "بیشتر...",
                                      style: TextStyle(
                                        color: Themes.text,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 9,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => setState(() => showComment = !showComment),
                                    child: Text(
                                      !showComment ? "نمایش نظرات (${comments.length})" : "فایل های دفتر املاک",
                                      style: TextStyle(
                                        color: Themes.text,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 9,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizeTransition(
              sizeFactor: _collopsAnimation,
              axis: Axis.vertical,
              child: profileDetail(),
            ),
            if (!moreDetail && !showComment) searchBar(),
            if (showCommentWidget) addCommentWidget(),
            Expanded(
              child: ListView.builder(
                itemCount: showComment ? comments.length : list.length,
                itemBuilder: (context, i) => showComment ? commentItem(comments[i]) : fileItem(list[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Themes.appBar,
      elevation: 0.7,
      automaticallyImplyLeading: false,
      leading: MyBackButton(),
      titleSpacing: 0,
      title: AppBarTitle("املاک برج"),
      actions: [
        IconButton(onPressed: share, icon: icon(Icons.share_rounded)),
        MyPopupMenuButton(itemBuilder: (_) => []),
      ],
    );
  }

  Widget searchBar() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
          top: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Themes.text, width: 1),
                ),
              ),
              child: TextField2(
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "جستجو در امللاک برج",
                  border: InputBorder.none,
                  isDense: true,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade300,
                    fontSize: 11,
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                style: TextStyle(
                  color: Themes.text,
                  fontSize: 11,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: openFileBox,
            icon: icon(OctIcons.sliders_16, size: 15),
            constraints: BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget addCommentWidget() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text(
            "امتیاز شما",
            style: TextStyle(color: Themes.text, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: RatingBar.builder(
              initialRating: 4.5,
              minRating: 1,
              direction: Axis.horizontal,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 15),
              itemBuilder: (context, _) => icon(Icons.star, color: Colors.amber),
              itemSize: 35,
              onRatingUpdate: (double value) => rating = value,
              glow: false,
              unratedColor: Colors.grey.shade200,
            ),
          ),
          TextField2(
            style: TextStyle(
              fontSize: 12,
            ),
            maxLines: 8,
            minLines: 4,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "توضیحات",
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: MaterialButton(
              onPressed: sendComment,
              color: Themes.primary,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "ثبت",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget card({required String title, required String value, void Function()? onTap}) {
    return Expanded(
      child: MyTextButton(
        onPressed: () {},
        rippleColor: Colors.grey,
        child: Container(
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Themes.text,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: Themes.textGrey,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget commentItem(Map<String, dynamic> comment) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Avatar(
                    size: 40,
                    imagePath: "https://blog.logrocket.com/wp-content/uploads/2021/04/10-best-Tailwind-CSS-component-and-template-collections.png",
                  ),
                  SizedBox(width: 10),
                  Text(
                    comment["user"]["username"],
                    style: TextStyle(
                      color: Themes.textGrey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  RatingBar.builder(
                    initialRating: comment["star"],
                    minRating: 1,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 0.25),
                    itemBuilder: (context, _) => icon(Icons.star, color: Colors.amber),
                    itemSize: 10,
                    onRatingUpdate: (double value) {},
                    updateOnDrag: false,
                    ignoreGestures: true,
                    unratedColor: Colors.grey.shade300,
                  ),
                  Text(
                    comment["date"],
                    style: TextStyle(
                      color: Themes.textGrey,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            constraints: BoxConstraints(
              minHeight: 40,
            ),
            padding: const EdgeInsets.only(right: 5, top: 10, bottom: 10),
            child: Text(
              // comment["comment"],
              "oiskdi ko kasdoksofk podfkdpo kf oidkoik oikdksfds f0dkf 0o9sfkd90sfkd90kf0d9skf d90sfkds90 fkd90sfkd90s fk d9dsfd9sfj89ke90ewjo9j 90jfoej r90ejr poj90j9efjo pjds90ocpj 90[jfo lmj 0jmf[9ejolmj9ko90j opfj90 joinj0iokj0 kj90 joijoij 90j [90jpo cmj0fj0inm0injf[ij[o0 k0[mnj0[oinj90in0[njklopmkcofe",
              style: TextStyle(
                color: Themes.textGrey,
                fontSize: 11,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  MyTextIconButton(
                    onPressed: () => like(comment),
                    icon: icon(Icons.thumb_up_alt_outlined, size: 15),
                    text: "122",
                    rippleColor: Themes.text,
                  ),
                  MyTextIconButton(
                    onPressed: () => dislike(comment),
                    icon: icon(Icons.thumb_down_alt_outlined, size: 15),
                    text: "1",
                    rippleColor: Themes.text,
                  ),
                ],
              ),
              MyTextButton(
                rippleColor: Themes.text,
                padding: EdgeInsets.zero,
                onPressed: () => answer(comment),
                child: Text(
                  "پاسخ",
                  style: TextStyle(
                    color: Themes.text,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (comment["answers"] != null && (comment["answers"] as List).length > 0)
            Column(
              children: (comment["answers"] as List).map((answer) => answerItem(answer)).toList(),
            ),
        ],
      ),
    );
  }

  Widget answerItem(Map<String, dynamic> answer) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 4, left: 12, right: 12),
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Avatar(
                    size: 25,
                    imagePath: "https://blog.logrocket.com/wp-content/uploads/2021/04/10-best-Tailwind-CSS-component-and-template-collections.png",
                  ),
                  SizedBox(width: 5),
                  Text(
                    answer["user"]["username"],
                    style: TextStyle(
                      color: Themes.textGrey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Text(
                answer["date"],
                style: TextStyle(
                  color: Themes.textGrey,
                  fontSize: 9,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            answer["comment"],
            style: TextStyle(
              fontSize: 11,
              color: Themes.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget profileDetail() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height - 276,
      ),
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: ListView(
        children: [
          Text(
            "fdkfdspf p[kfpdkl dk ofkp[ ko kk okokdoflk olkokpfkdsfldsfkdfodsfdoskofdsjiofdskfojsdffoidjsfiodf'dposfjoihjdoifdifjdsjifdfoidsjfdposjfdsofijdsoifdjsofidjsfdkf podmnsf fdkfdspf p[kfpdkl dk ofkp[ ko kk okokdoflk olkokpfkdsfldsfkdfodsfdoskofdsjiofdskfojsdffoidjsfiodf'dposfjoihjdoifdifjdsjifdfoidsjfdposjfdsofijdsoifdjsofidjsfdkf podmnsf fdkfdspf p[kfpdkl dk ofkp[ ko kk okokdoflk olkokpfkdsfldsfkdfodsfdoskofdsjiofdskfojsdffoidjsfiodf'dposfjoihjdoifdifjdsjifdfoidsjfdposjfdsofijdsoifdjsofidjsfdkf podmnsf ",
            style: TextStyle(
              color: Themes.textGrey,
              fontSize: 11,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            child: AspectRatio(
              aspectRatio: 2.1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image(
                  image: NetworkImage("https://blog.logrocket.com/wp-content/uploads/2021/04/10-best-Tailwind-CSS-component-and-template-collections.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              // padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: 10,
              itemBuilder: (context, i) => agencyImageItem(),
            ),
          ),
          divider(),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: Text(
              "مشاورین املاک برج",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Themes.text,
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, i) => agentItem(),
            ),
          ),
        ],
      ),
    );
  }

  Widget agencyImageItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image(
          image: NetworkImage("https://blog.logrocket.com/wp-content/uploads/2021/04/10-best-Tailwind-CSS-component-and-template-collections.png"),
          height: 50,
          width: 70,
          fit: BoxFit.fill,
          loadingBuilder: (context, child, progressEvent) {
            if (progressEvent == null) return child;
            return Container(
              height: 50,
              width: 70,
              color: Colors.grey.shade200,
            );
          },
        ),
      ),
    );
  }

  Widget agentItem() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Avatar(size: 45, imagePath: "https://blog.logrocket.com/wp-content/uploads/2021/04/10-best-Tailwind-CSS-component-and-template-collections.png"),
          SizedBox(height: 5),
          Text(
            "عباس رحیمی",
            style: TextStyle(
              color: Themes.textGrey,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          StaticStar(rating: 4.5),
        ],
      ),
    );
  }

  void _collopsControllerListener() => setState(() {});

  void share() {
    //todo: implement event listener
  }

  void viewComments() {
    //todo: implement event listener
  }

  void openFileBox() {
    //todo: implement event listener
  }

  Widget fileItem(File file) {
    return FileHorizontalItem(file: file);
  }

  void like(Map<String, dynamic> comment) {
    //todo: implement event listener
  }

  void answer(Map<String, dynamic> comment) {
    //todo: implement event listener
  }

  void dislike(Map<String, dynamic> comment) {}

  void viewMoreDetail() {
    setState(() {
      moreDetail = !moreDetail;

      if (moreDetail) {
        _collopsController.forward();
      } else {
        _collopsController.reverse();
      }
    });
  }

  void sendComment() {}
}
